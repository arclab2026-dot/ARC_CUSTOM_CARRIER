puts "============================================================"
puts "ARC - UPGRADE CUSTOM IP ONLY"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set IP_REPO [file normalize \
    "$ROOT_DIR/ip_repo/arc_ctrl_status_v1_0/arc_ctrl_status_1_0"]

open_project $ARC_XPR

set old_repos [get_property ip_repo_paths [current_project]]

if {[lsearch -exact $old_repos $IP_REPO] < 0} {
    set_property ip_repo_paths \
        [concat $old_repos [list $IP_REPO]] \
        [current_project]
}

update_ip_catalog -rebuild

set target_ip [get_ips -quiet system_arc_ctrl_status_0_0]

puts "TARGET_IP_COUNT=[llength $target_ip]"

if {[llength $target_ip] != 1} {
    puts "ERROR: custom IP instance not found"
    exit 2
}

puts "TARGET_IP=$target_ip"

upgrade_ip \
    -vlnv agileradiocom.com:user:arc_ctrl_status:1.0 \
    $target_ip

puts "CUSTOM_IP_UPGRADE_DONE=1"

report_ip_status -file \
    "$ROOT_DIR/evidence/22B_IP_STATUS_AFTER_UPGRADE.txt"

set bd_file [lindex [get_files -quiet */system.bd] 0]
open_bd_design $bd_file

validate_bd_design
save_bd_design

puts "ARC_CUSTOM_IP_UPGRADE_PASS=1"

close_project
exit 0
