puts "============================================================"
puts "ARC CUSTOM CARRIER - PL COUNTER READBACK"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set RTL_FILE [file normalize \
    "$ROOT_DIR/rtl/arc_counter8.v"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

# Add our custom HDL file.
if {[llength [get_files -quiet $RTL_FILE]] == 0} {
    add_files -norecurse $RTL_FILE
}

update_compile_order -fileset sources_1

set bd_file [lindex [get_files -quiet */system.bd] 0]
open_bd_design $bd_file

# ------------------------------------------------------------
# Remove the old fixed 0xA5 test value.
# ------------------------------------------------------------

set gpio2_pin [get_bd_pins axi_gpio_0/gpio2_io_i]

set old_nets [get_bd_nets -quiet -of_objects $gpio2_pin]

foreach net $old_nets {
    disconnect_bd_net $net $gpio2_pin
}

if {[llength [get_bd_cells -quiet pl_status_constant]] == 1} {
    delete_bd_objs [get_bd_cells pl_status_constant]
}

# ------------------------------------------------------------
# Add our custom counter as a module in the block design.
# ------------------------------------------------------------

create_bd_cell \
    -type module \
    -reference arc_counter8 \
    arc_counter8_0

# Clock the counter from the existing 100 MHz PL clock.
connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins arc_counter8_0/clk]

# Use the existing synchronized active-low reset.
connect_bd_net \
    [get_bd_pins rst_ps_100m/peripheral_aresetn] \
    [get_bd_pins arc_counter8_0/resetn]

# Send the counter value into AXI GPIO channel 2.
connect_bd_net \
    [get_bd_pins arc_counter8_0/count] \
    [get_bd_pins axi_gpio_0/gpio2_io_i]

save_bd_design
validate_bd_design

write_bd_tcl -force \
    "$ROOT_DIR/evidence/12_PL_COUNTER_READBACK_BD.tcl"

puts "COUNTER_CELL=[get_bd_cells arc_counter8_0]"
puts "COUNTER_WIDTH=8"
puts "COUNTER_CLOCK=pl_clk0"
puts "GPIO2_SOURCE=arc_counter8_0/count"

puts "ARC_PL_COUNTER_READBACK_PASS=1"

close_project
exit 0
