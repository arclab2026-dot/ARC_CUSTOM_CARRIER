puts "============================================================"
puts "ARC CUSTOM CARRIER - PL TO PS READBACK"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

set bd_file [lindex [get_files -quiet */system.bd] 0]

if {$bd_file eq ""} {
    puts "ERROR: system.bd not found"
    exit 2
}

open_bd_design $bd_file

set gpio [get_bd_cells axi_gpio_0]

if {[llength $gpio] != 1} {
    puts "ERROR: AXI GPIO not found"
    exit 3
}

# Turn AXI GPIO into a dual-channel peripheral.
# Channel 1 stays as our 8-bit output.
# Channel 2 becomes an 8-bit input.

set_property -dict [list \
    CONFIG.C_IS_DUAL {1} \
    CONFIG.C_GPIO2_WIDTH {8} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS_2 {0} \
] $gpio

# Create a fixed 8-bit test value inside the Programmable Logic.
create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:xlconstant:* \
    pl_status_constant

set_property -dict [list \
    CONFIG.CONST_WIDTH {8} \
    CONFIG.CONST_VAL {165} \
] [get_bd_cells pl_status_constant]

# Feed 0xA5 into AXI GPIO channel 2.
connect_bd_net \
    [get_bd_pins pl_status_constant/dout] \
    [get_bd_pins axi_gpio_0/gpio2_io_i]

save_bd_design
validate_bd_design

write_bd_tcl -force \
    "$ROOT_DIR/evidence/11_PL_TO_PS_READBACK_BD.tcl"

puts "GPIO_DUAL=[get_property CONFIG.C_IS_DUAL $gpio]"
puts "GPIO2_WIDTH=[get_property CONFIG.C_GPIO2_WIDTH $gpio]"
puts "GPIO2_ALL_INPUTS=[get_property CONFIG.C_ALL_INPUTS_2 $gpio]"
puts "PL_TEST_VALUE=0xA5"

puts "ARC_PL_TO_PS_READBACK_PASS=1"

close_project
exit 0
