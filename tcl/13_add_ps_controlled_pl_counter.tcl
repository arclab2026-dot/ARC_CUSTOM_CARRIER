puts "============================================================"
puts "ARC - PS CONTROLLED PL COUNTER"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set RTL_FILE [file normalize \
    "$ROOT_DIR/rtl/arc_controlled_counter8.v"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

if {[llength [get_files -quiet $RTL_FILE]] == 0} {
    add_files -norecurse $RTL_FILE
}

update_compile_order -fileset sources_1

set bd_file [lindex [get_files -quiet */system.bd] 0]
open_bd_design $bd_file

if {[llength [get_bd_cells -quiet arc_counter8_0]] == 1} {
    delete_bd_objs [get_bd_cells arc_counter8_0]
}

create_bd_cell \
    -type module \
    -reference arc_controlled_counter8 \
    arc_controlled_counter8_0

connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins arc_controlled_counter8_0/clk]

connect_bd_net \
    [get_bd_pins rst_ps_100m/peripheral_aresetn] \
    [get_bd_pins arc_controlled_counter8_0/resetn]

connect_bd_net \
    [get_bd_pins axi_gpio_0/gpio_io_o] \
    [get_bd_pins arc_controlled_counter8_0/control]

connect_bd_net \
    [get_bd_pins arc_controlled_counter8_0/count] \
    [get_bd_pins axi_gpio_0/gpio2_io_i]

save_bd_design
validate_bd_design

write_bd_tcl -force \
    "$ROOT_DIR/evidence/13_PS_CONTROLLED_PL_COUNTER_BD.tcl"

puts "COUNTER_CELL=[get_bd_cells arc_controlled_counter8_0]"
puts "CONTROL_SOURCE=axi_gpio_0/gpio_io_o"
puts "STATUS_SOURCE=arc_controlled_counter8_0/count"

puts "CONTROL_BIT0=ENABLE"
puts "CONTROL_BIT1=CLEAR"

puts "ARC_PS_CONTROLLED_COUNTER_PASS=1"

close_project
exit 0
