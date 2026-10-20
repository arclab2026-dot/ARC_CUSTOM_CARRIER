puts "============================================================"
puts "ARC - REPACKAGE CUSTOM AXI4-LITE IP"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set COMPONENT_XML [file normalize \
    "$ROOT_DIR/ip_repo/arc_ctrl_status_v1_0/arc_ctrl_status_1_0/component.xml"]

set EDIT_DIR [file normalize \
    "$ROOT_DIR/build/ip_edit/arc_ctrl_status"]

if {![file exists $ARC_XPR]} {
    puts "ERROR: ARC Vivado project not found"
    exit 2
}

if {![file exists $COMPONENT_XML]} {
    puts "ERROR: component.xml not found"
    exit 3
}

# Open the real ARC Vivado project.
open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

# Recreate the temporary IP editing area.
file delete -force $EDIT_DIR
file mkdir $EDIT_DIR

# Open the packaged IP for editing.
ipx::edit_ip_in_project \
    -upgrade true \
    -name arc_ctrl_status_edit \
    -directory $EDIT_DIR \
    $COMPONENT_XML

set core [ipx::current_core]

# Pull the new Verilog ports into the IP metadata.
ipx::merge_project_changes ports $core

# Refresh file checksums.
ipx::update_checksums $core

# Save the updated IP package.
ipx::save_core $core

puts "COMPONENT_XML=$COMPONENT_XML"
puts "ARC_CUSTOM_AXI_IP_REPACKAGE_PASS=1"

close_project
exit 0
