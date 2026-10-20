puts "============================================================"
puts "ARC - REFRESH FINAL CUSTOM AXI4-LITE IP"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set IP_REPO [file normalize \
    "$ROOT_DIR/ip_repo/arc_ctrl_status_v1_0/arc_ctrl_status_1_0"]

set XSA_FILE [file normalize \
    "$ROOT_DIR/build/handoff/arc_uzev_custom_registers_presynth.xsa"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

# Refresh custom IP repository.
set old_repos [get_property ip_repo_paths [current_project]]

if {[lsearch -exact $old_repos $IP_REPO] < 0} {
    set_property ip_repo_paths \
        [concat $old_repos [list $IP_REPO]] \
        [current_project]
}

update_ip_catalog -rebuild

# Open real block design.
set bd_file [lindex [get_files -quiet */system.bd] 0]
open_bd_design $bd_file

# Confirm custom IP is still present.
set custom_ip [get_bd_cells -quiet arc_ctrl_status_0]

if {[llength $custom_ip] != 1} {
    puts "ERROR: custom register IP not found"
    exit 2
}

puts "CUSTOM_IP=$custom_ip"
puts "CUSTOM_IP_VLNV=[get_property VLNV $custom_ip]"

# Confirm custom ports remain visible.
puts "CONTROL_PORT_COUNT=[llength \
    [get_bd_pins -quiet arc_ctrl_status_0/control_o]]"

puts "STATUS_PORT_COUNT=[llength \
    [get_bd_pins -quiet arc_ctrl_status_0/status_i]]"

# Validate and regenerate outputs.
validate_bd_design
save_bd_design

reset_target all $bd_file
generate_target all $bd_file

write_bd_tcl -force \
    "$ROOT_DIR/evidence/22_FINAL_CUSTOM_REGISTER_BD.tcl"

# Export new hardware checkpoint.
write_hw_platform \
    -fixed \
    -force \
    $XSA_FILE

puts "XSA_FILE=$XSA_FILE"
puts "XSA_SIZE=[file size $XSA_FILE]"

puts "ARC_FINAL_CUSTOM_REGISTER_REFRESH_PASS=1"

close_project
exit 0
