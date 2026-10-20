puts "============================================================"
puts "ARC CUSTOM CARRIER - FIRST PS TO PL AXI DESIGN"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set EXPECTED_PART "xczu7ev-fbvb900-1-e"

# ============================================================
# Helper: make sure a PS property exists before using it
# ============================================================

proc require_ps_property {ps prop} {

    if {[lsearch -exact [list_property $ps] $prop] < 0} {
        puts "ERROR: Required PS property not found: $prop"
        exit 10
    }

    puts "PROPERTY_FOUND=$prop"
}

# ============================================================
# 1. Open existing ARC project
# ============================================================

if {![file exists $ARC_XPR]} {
    puts "ERROR: ARC project not found: $ARC_XPR"
    exit 2
}

open_project $ARC_XPR

set actual_part [get_property PART [current_project]]

puts "PROJECT_PART=$actual_part"

if {$actual_part ne $EXPECTED_PART} {
    puts "ERROR: Wrong FPGA target"
    exit 3
}

# ============================================================
# 2. Open the existing system block design
# ============================================================

set bd_files [get_files -quiet */system.bd]

if {[llength $bd_files] != 1} {
    puts "ERROR: Expected exactly one system.bd"
    exit 4
}

open_bd_design [lindex $bd_files 0]

set ps [get_bd_cells zynq_ultra_ps_e_0]

if {[llength $ps] != 1} {
    puts "ERROR: Zynq UltraScale+ PS not found"
    exit 5
}

# ============================================================
# 3. Verify the PS properties we're about to use
# ============================================================

require_ps_property $ps CONFIG.PSU__USE__M_AXI_GP0
require_ps_property $ps CONFIG.PSU__FPGA_PL0_ENABLE
require_ps_property $ps CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ

# ============================================================
# 4. Enable one PS -> PL AXI master and one PL clock
# ============================================================

set_property -dict [list \
    CONFIG.PSU__USE__M_AXI_GP0 {1} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {0} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
] $ps

# Enable at least one PS-generated PL reset if this version
# of the PS IP exposes the setting.

if {[lsearch -exact [list_property $ps] \
        CONFIG.PSU__NUM_FABRIC_RESETS] >= 0} {

    set_property CONFIG.PSU__NUM_FABRIC_RESETS {1} $ps

    puts "FABRIC_RESET_PROPERTY=CONFIG.PSU__NUM_FABRIC_RESETS"
}

save_bd_design

# ============================================================
# 5. Verify the PS ports appeared
# ============================================================

set axi_master [get_bd_intf_pins -quiet \
    zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

set pl_clk [get_bd_pins -quiet \
    zynq_ultra_ps_e_0/pl_clk0]

set pl_resetn [get_bd_pins -quiet \
    zynq_ultra_ps_e_0/pl_resetn0]

if {[llength $axi_master] != 1} {
    puts "ERROR: M_AXI_HPM0_FPD did not appear"
    exit 20
}

if {[llength $pl_clk] != 1} {
    puts "ERROR: pl_clk0 did not appear"
    exit 21
}

if {[llength $pl_resetn] != 1} {
    puts "ERROR: pl_resetn0 did not appear"
    exit 22
}

puts "AXI_MASTER_PRESENT=1"
puts "PL_CLK0_PRESENT=1"
puts "PL_RESETN0_PRESENT=1"

# ============================================================
# 6. Create AXI GPIO
# ============================================================

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:axi_gpio:* \
    axi_gpio_0

set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {8} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_IS_DUAL {0} \
] [get_bd_cells axi_gpio_0]

# ============================================================
# 7. Create AXI Interconnect
# ============================================================

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:axi_interconnect:* \
    axi_interconnect_0

set_property -dict [list \
    CONFIG.NUM_SI {1} \
    CONFIG.NUM_MI {1} \
] [get_bd_cells axi_interconnect_0]

# ============================================================
# 8. Create synchronized PL reset controller
# ============================================================

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:proc_sys_reset:* \
    rst_ps_100m

# PS reset output pl_resetn0 is active-low.
set_property \
    CONFIG.C_EXT_RESET_HIGH {0} \
    [get_bd_cells rst_ps_100m]

# The reset controller expects a clock-stable indication.
# Since pl_clk0 comes directly from the PS, provide logic '1'.

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:xlconstant:* \
    reset_clock_locked

set_property -dict [list \
    CONFIG.CONST_WIDTH {1} \
    CONFIG.CONST_VAL {1} \
] [get_bd_cells reset_clock_locked]

# ============================================================
# 9. Connect the AXI data path
# ============================================================

connect_bd_intf_net \
    [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] \
    [get_bd_intf_pins axi_interconnect_0/S00_AXI]

connect_bd_intf_net \
    [get_bd_intf_pins axi_interconnect_0/M00_AXI] \
    [get_bd_intf_pins axi_gpio_0/S_AXI]

# ============================================================
# 10. Connect the 100 MHz clock
# ============================================================

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_interconnect_0/ACLK]

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_interconnect_0/S00_ACLK]

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_interconnect_0/M00_ACLK]

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_gpio_0/s_axi_aclk]

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins rst_ps_100m/slowest_sync_clk]

# ============================================================
# 11. Connect reset sources
# ============================================================

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] \
    [get_bd_pins rst_ps_100m/ext_reset_in]

connect_bd_net \
    [get_bd_pins reset_clock_locked/dout] \
    [get_bd_pins rst_ps_100m/dcm_locked]

# AXI interconnect reset
connect_bd_net \
    [get_bd_pins rst_ps_100m/interconnect_aresetn] \
    [get_bd_pins axi_interconnect_0/ARESETN]

connect_bd_net \
    [get_bd_pins rst_ps_100m/interconnect_aresetn] \
    [get_bd_pins axi_interconnect_0/S00_ARESETN]

connect_bd_net \
    [get_bd_pins rst_ps_100m/interconnect_aresetn] \
    [get_bd_pins axi_interconnect_0/M00_ARESETN]

# AXI GPIO reset
connect_bd_net \
    [get_bd_pins rst_ps_100m/peripheral_aresetn] \
    [get_bd_pins axi_gpio_0/s_axi_aresetn]

# ============================================================
# 12. Create an 8-bit PL output
# ============================================================

create_bd_port \
    -dir O \
    -from 7 \
    -to 0 \
    demo_gpio_o

connect_bd_net \
    [get_bd_pins axi_gpio_0/gpio_io_o] \
    [get_bd_ports demo_gpio_o]

# ============================================================
# 13. Assign the GPIO a processor-visible address
# ============================================================

assign_bd_address

# ============================================================
# 14. Validate and save
# ============================================================

validate_bd_design
save_bd_design

write_bd_tcl -force \
    "$ROOT_DIR/evidence/08_FIRST_PS_PL_AXI_GPIO_BD.tcl"

# ============================================================
# 15. Report useful architecture information
# ============================================================

puts ""
puts "------------------------------------------------------------"
puts "FIRST PS -> PL AXI DESIGN"
puts "------------------------------------------------------------"

puts "M_AXI_GP0=[get_property CONFIG.PSU__USE__M_AXI_GP0 $ps]"
puts "PL0_ENABLE=[get_property CONFIG.PSU__FPGA_PL0_ENABLE $ps]"
puts "PL0_REQUESTED_MHZ=[get_property CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ $ps]"

puts ""
puts "BLOCKS:"

foreach cell [get_bd_cells] {
    puts "CELL=$cell"
}

puts ""
puts "ADDRESS MAP:"

foreach seg [get_bd_addr_segs \
        -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]] {

    puts "ADDR_SEG=$seg"
    puts "  OFFSET=[get_property OFFSET $seg]"
    puts "  RANGE=[get_property RANGE $seg]"
}

puts ""
puts "ARC_AXI_GPIO_BASE_PASS=1"
puts "============================================================"

close_project
exit 0
