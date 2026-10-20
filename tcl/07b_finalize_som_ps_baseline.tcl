puts "============================================================"
puts "ARC CUSTOM CARRIER - FINALIZE SOM PS BASELINE"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set EXPECTED_PART "xczu7ev-fbvb900-1-e"

if {![file exists $ARC_XPR]} {
    puts "ERROR: ARC project not found: $ARC_XPR"
    exit 2
}

# ------------------------------------------------------------
# Open the real ARC Vivado project
# ------------------------------------------------------------

open_project $ARC_XPR

set actual_part [get_property PART [current_project]]

puts "PROJECT_PART=$actual_part"

if {$actual_part ne $EXPECTED_PART} {
    puts "ERROR: Wrong FPGA target"
    exit 3
}

# ------------------------------------------------------------
# Open our existing system block design
# ------------------------------------------------------------

set bd_files [get_files -quiet */system.bd]

if {[llength $bd_files] != 1} {
    puts "ERROR: Expected exactly one system.bd"
    exit 4
}

open_bd_design [lindex $bd_files 0]

set ps [get_bd_cells zynq_ultra_ps_e_0]

if {[llength $ps] != 1} {
    puts "ERROR: Zynq UltraScale+ PS cell not found"
    exit 5
}

# ------------------------------------------------------------
# Disable PS -> PL AXI masters for the SOM-only baseline.
#
# GP0 -> M_AXI_HPM0_FPD
# GP1 -> M_AXI_HPM1_FPD
# GP2 -> M_AXI_HPM0_LPD
#
# We will intentionally enable one later when we build
# the first PS -> PL AXI peripheral.
# ------------------------------------------------------------

set_property -dict [list \
    CONFIG.PSU__USE__M_AXI_GP0 0 \
    CONFIG.PSU__USE__M_AXI_GP1 0 \
    CONFIG.PSU__USE__M_AXI_GP2 0 \
] $ps

save_bd_design

# ------------------------------------------------------------
# Validate the now-clean SOM-only block design
# ------------------------------------------------------------

validate_bd_design

# ------------------------------------------------------------
# Save a reproducible Tcl snapshot of this known-good baseline
# ------------------------------------------------------------

write_bd_tcl -force \
    "$ROOT_DIR/evidence/07B_SOM_PS_BASELINE_BD.tcl"

# ------------------------------------------------------------
# Report the important configuration
# ------------------------------------------------------------

puts ""
puts "------------------------------------------------------------"
puts "SOM BASELINE CONFIGURATION"
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

    CONFIG.PSU__USE__M_AXI_GP0
    CONFIG.PSU__USE__M_AXI_GP1
    CONFIG.PSU__USE__M_AXI_GP2

    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE
}

foreach p $report_props {
    puts "$p=[get_property $p $ps]"
}

puts ""
puts "------------------------------------------------------------"
puts "ACTIVE PS INTERFACES"
puts "------------------------------------------------------------"

foreach intf [get_bd_intf_pins $ps/*] {
    puts "INTF=$intf"
}

puts "------------------------------------------------------------"
puts "ARC_SOM_PS_BASELINE_PASS=1"
puts "============================================================"

close_project
exit 0
