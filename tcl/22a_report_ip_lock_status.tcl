puts "============================================================"
puts "ARC - REPORT IP LOCK STATUS"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set IP_REPO [file normalize \
    "$ROOT_DIR/ip_repo/arc_ctrl_status_v1_0/arc_ctrl_status_1_0"]

set REPORT_FILE [file normalize \
    "$ROOT_DIR/evidence/22A_IP_STATUS.txt"]

open_project $ARC_XPR

set old_repos [get_property ip_repo_paths [current_project]]

if {[lsearch -exact $old_repos $IP_REPO] < 0} {
    set_property ip_repo_paths \
        [concat $old_repos [list $IP_REPO]] \
        [current_project]
}

update_ip_catalog -rebuild

report_ip_status -file $REPORT_FILE

puts "IP_STATUS_REPORT=$REPORT_FILE"
puts "ARC_IP_STATUS_REPORT_PASS=1"

close_project
exit 0
