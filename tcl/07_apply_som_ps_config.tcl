puts "============================================================"
puts "ARC CUSTOM CARRIER - APPLY ULTRAZED SOM PS CONFIG"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set PRESET_XML [file normalize \
    "$ROOT_DIR/reference/vendor/avnet_bdf/ultrazed_7ev_cc/1.6/preset.xml"]

set EXPECTED_PART "xczu7ev-fbvb900-1-e"

if {![file exists $ARC_XPR]} {
    puts "ERROR: ARC project not found: $ARC_XPR"
    exit 2
}

if {![file exists $PRESET_XML]} {
    puts "ERROR: Avnet preset not found: $PRESET_XML"
    exit 3
}

# ------------------------------------------------------------
# Decide which Avnet parameters belong to the SOM baseline.
#
# KEEP:
#   - PS DDR4
#   - QSPI
#   - eMMC / SD0
#   - UART0
#   - PS reference clock / related PLL sources
#   - PS bank I/O voltage standards
#
# DO NOT COPY:
#   - PCIe
#   - SATA
#   - USB3
#   - DisplayPort
#   - Avnet carrier-specific peripherals
# ------------------------------------------------------------

proc arc_keep_param {p} {

    if {[regexp {^CONFIG\.PSU_BANK_[0-3]_IO_STANDARD$} $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__DDRC__*" $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__CRF_APB__DDR_CTRL__*" $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__QSPI__*" $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__*" $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__SD0__*" $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__*" $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__UART0__*" $p]} {
        return 1
    }

    if {[string match "CONFIG.PSU__CRL_APB__UART0_REF_CTRL__*" $p]} {
        return 1
    }

    if {$p eq "CONFIG.PSU__PSS_REF_CLK__FREQMHZ"} {
        return 1
    }

    foreach pll {
        CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL
        CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL
        CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL
        CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL
        CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL
    } {
        if {$p eq $pll} {
            return 1
        }
    }

    return 0
}

# ------------------------------------------------------------
# Parse the official Avnet preset XML.
# ------------------------------------------------------------

set fh [open $PRESET_XML r]
set xml_text [read $fh]
close $fh

set config_dict [list]
set config_count 0

foreach line [split $xml_text "\n"] {

    if {[regexp \
        {<user_parameter name="([^"]+)" value="([^"]*)"[[:space:]]*/>} \
        $line -> pname pvalue]} {

        if {[arc_keep_param $pname]} {
            lappend config_dict $pname $pvalue
            incr config_count
        }
    }
}

puts "PRESET_XML=$PRESET_XML"
puts "SOM_CONFIG_PARAMETER_COUNT=$config_count"

if {$config_count == 0} {
    puts "ERROR: no SOM parameters extracted"
    exit 4
}

# ------------------------------------------------------------
# Open the REAL ARC project.
# ------------------------------------------------------------

open_project $ARC_XPR

set actual_part [get_property PART [current_project]]

puts "PROJECT_PART=$actual_part"

if {$actual_part ne $EXPECTED_PART} {
    puts "ERROR: wrong ARC FPGA target"
    exit 5
}

set bd_files [get_files -quiet */system.bd]

if {[llength $bd_files] != 1} {
    puts "ERROR: expected exactly one system.bd"
    exit 6
}

open_bd_design [lindex $bd_files 0]

set ps [get_bd_cells zynq_ultra_ps_e_0]

if {[llength $ps] != 1} {
    puts "ERROR: Zynq PS cell not found"
    exit 7
}

# Save the original unconfigured BD as evidence.
write_bd_tcl -force \
    "$ROOT_DIR/evidence/07_PRE_SOM_CONFIG_BD.tcl"

# ------------------------------------------------------------
# Apply SOM-level configuration.
# ------------------------------------------------------------

set_property -dict $config_dict $ps

# ------------------------------------------------------------
# Explicitly keep Avnet-carrier-only interfaces disabled.
# ------------------------------------------------------------

set_property -dict [list \
    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE 0 \
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE 0 \
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE 0 \
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE 0 \
] $ps

save_bd_design
validate_bd_design

write_bd_tcl -force \
    "$ROOT_DIR/evidence/07_ARC_SOM_PS_CONFIGURED_BD.tcl"

# ------------------------------------------------------------
# Report important settings.
# ------------------------------------------------------------

puts "------------------------------------------------------------"
puts "ARC SOM CONFIGURATION"
puts "------------------------------------------------------------"

set report_props {
    CONFIG.PSU__DDRC__ENABLE
    CONFIG.PSU__DDRC__MEMORY_TYPE
    CONFIG.PSU__DDRC__BUS_WIDTH
    CONFIG.PSU__DDRC__DRAM_WIDTH
    CONFIG.PSU__DDRC__SPEED_BIN

    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE
    CONFIG.PSU__QSPI__PERIPHERAL__MODE
    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE
    CONFIG.PSU__QSPI__PERIPHERAL__IO

    CONFIG.PSU__SD0__PERIPHERAL__ENABLE
    CONFIG.PSU__SD0__SLOT_TYPE
    CONFIG.PSU__SD0__DATA_TRANSFER_MODE
    CONFIG.PSU__SD0__PERIPHERAL__IO

    CONFIG.PSU__UART0__PERIPHERAL__ENABLE
    CONFIG.PSU__UART0__PERIPHERAL__IO
    CONFIG.PSU__UART0__BAUD_RATE

    CONFIG.PSU__PSS_REF_CLK__FREQMHZ

    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE
}

foreach p $report_props {
    puts "$p=[get_property $p $ps]"
}

puts "------------------------------------------------------------"
puts "ARC_SOM_PS_CONFIG_PASS=1"
puts "============================================================"

close_project
exit 0
