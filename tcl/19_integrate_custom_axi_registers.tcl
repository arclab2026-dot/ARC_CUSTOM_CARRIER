puts "============================================================"
puts "ARC - INTEGRATE CUSTOM AXI4-LITE REGISTERS"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set IP_REPO [file normalize \
    "$ROOT_DIR/ip_repo/arc_ctrl_status_v1_0/arc_ctrl_status_1_0"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

# Make the custom IP visible to this project.
set old_repos [get_property ip_repo_paths [current_project]]
set_property ip_repo_paths \
    [concat $old_repos [list $IP_REPO]] \
    [current_project]

update_ip_catalog -rebuild

# Open the main block design.
set bd_file [lindex [get_files -quiet */system.bd] 0]
open_bd_design $bd_file

# Remove the training AXI GPIO peripheral.
if {[llength [get_bd_cells -quiet axi_gpio_0]] == 1} {
    delete_bd_objs [get_bd_cells axi_gpio_0]
}

# Add our custom AXI4-Lite register block.
create_bd_cell \
    -type ip \
    -vlnv agileradiocom.com:user:arc_ctrl_status:1.0 \
    arc_ctrl_status_0

# Connect the AXI bus.
connect_bd_intf_net \
    [get_bd_intf_pins axi_interconnect_0/M00_AXI] \
    [get_bd_intf_pins arc_ctrl_status_0/S_AXI]

# Connect the existing 100 MHz clock.
connect_bd_net \
    [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins arc_ctrl_status_0/s_axi_aclk]

# Connect the existing synchronized reset.
connect_bd_net \
    [get_bd_pins rst_ps_100m/peripheral_aresetn] \
    [get_bd_pins arc_ctrl_status_0/s_axi_aresetn]

# CONTROL register -> counter control.
connect_bd_net \
    [get_bd_pins arc_ctrl_status_0/control_o] \
    [get_bd_pins arc_controlled_counter8_0/control]

# Counter value -> STATUS register.
connect_bd_net \
    [get_bd_pins arc_controlled_counter8_0/count] \
    [get_bd_pins arc_ctrl_status_0/status_i]

# Find the custom IP address segment.
set slave_segs [get_bd_addr_segs -quiet \
    -of_objects [get_bd_intf_pins arc_ctrl_status_0/S_AXI]]

if {[llength $slave_segs] != 1} {
    puts "ERROR: Expected one custom IP address segment"
    puts "SEGMENT_COUNT=[llength $slave_segs]"
    exit 2
}

set slave_seg [lindex $slave_segs 0]

# Preserve our documented base address.
assign_bd_address \
    -offset 0xA0000000 \
    -range 64K \
    -target_address_space \
    [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] \
    $slave_seg

save_bd_design
validate_bd_design

write_bd_tcl -force \
    "$ROOT_DIR/evidence/19_CUSTOM_AXI_REGISTER_BD.tcl"

puts "CUSTOM_IP=[get_bd_cells arc_ctrl_status_0]"
puts "CONTROL_CONNECTION=arc_ctrl_status_0/control_o"
puts "STATUS_CONNECTION=arc_ctrl_status_0/status_i"

foreach seg [get_bd_addr_segs \
    -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]] {

    if {[string match "*arc_ctrl_status*" $seg]} {
        puts "ADDR_SEG=$seg"
        puts "OFFSET=[get_property OFFSET $seg]"
        puts "RANGE=[get_property RANGE $seg]"
    }
}

puts "ARC_CUSTOM_AXI_REGISTER_INTEGRATION_PASS=1"

close_project
exit 0
