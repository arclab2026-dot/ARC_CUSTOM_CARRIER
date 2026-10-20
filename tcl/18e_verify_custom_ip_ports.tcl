puts "============================================================"
puts "ARC - VERIFY CUSTOM IP PORTS"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set IP_REPO [file normalize \
    "$ROOT_DIR/ip_repo/arc_ctrl_status_v1_0/arc_ctrl_status_1_0"]

set PART "xczu7ev-fbvb900-1-e"

create_project -in_memory -part $PART

set_property ip_repo_paths [list $IP_REPO] [current_project]
update_ip_catalog -rebuild

create_bd_design "verify_ip"

create_bd_cell \
    -type ip \
    -vlnv agileradiocom.com:user:arc_ctrl_status:1.0 \
    arc_ctrl_status_0

set control_pin [get_bd_pins -quiet arc_ctrl_status_0/control_o]
set status_pin  [get_bd_pins -quiet arc_ctrl_status_0/status_i]

puts "CONTROL_PORT_COUNT=[llength $control_pin]"
puts "STATUS_PORT_COUNT=[llength $status_pin]"

if {[llength $control_pin] != 1} {
    puts "ERROR: control_o not found"
    exit 2
}

if {[llength $status_pin] != 1} {
    puts "ERROR: status_i not found"
    exit 3
}

puts "CONTROL_PORT=$control_pin"
puts "STATUS_PORT=$status_pin"

puts "ARC_CUSTOM_IP_PORT_VERIFY_PASS=1"

exit 0
