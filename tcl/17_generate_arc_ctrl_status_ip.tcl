puts "============================================================"
puts "ARC - GENERATE CUSTOM AXI4-LITE CONTROL/STATUS IP"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set IP_DIR [file normalize \
    "$ROOT_DIR/ip_repo/arc_ctrl_status_v1_0"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"
puts "IP_DIR=$IP_DIR"

# Avoid overwriting an existing custom IP accidentally.
if {[file exists $IP_DIR]} {
    puts "ERROR: IP directory already exists"
    exit 2
}

# Create the peripheral framework.
set peripheral [create_peripheral \
    {agileradiocom.com} \
    {user} \
    {arc_ctrl_status} \
    {1.0} \
    -dir $IP_DIR]

# Add one AXI4-Lite slave interface.
add_peripheral_interface \
    {S_AXI} \
    -interface_mode {slave} \
    -axi_type {lite} \
    $peripheral

# Generate the Hardware Description Language framework.
generate_peripheral $peripheral

# Write the Vivado IP package files.
write_peripheral $peripheral

# Add our custom IP repository to the project.
set_property ip_repo_paths \
    [list $IP_DIR] \
    [current_fileset]

update_ip_catalog -rebuild

puts "IP_NAME=arc_ctrl_status"
puts "IP_VERSION=1.0"
puts "AXI_INTERFACE=S_AXI"
puts "AXI_TYPE=AXI4-LITE"
puts "ARC_CUSTOM_AXI_IP_GENERATE_PASS=1"

close_project
exit 0
