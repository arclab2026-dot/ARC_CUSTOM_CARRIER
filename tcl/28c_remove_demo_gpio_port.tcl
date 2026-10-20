puts "============================================================"
puts "ARC - REMOVE TEMPORARY DEMO GPIO PORT"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

open_project $ARC_XPR

set bd_file [lindex [get_files -quiet */system.bd] 0]
open_bd_design $bd_file

set port [get_bd_ports -quiet demo_gpio_o]

puts "PORT_COUNT_BEFORE=[llength $port]"

if {[llength $port] == 1} {

    set nets [get_bd_nets -quiet -of_objects $port]

    foreach net $nets {
        disconnect_bd_net $net $port
    }

    delete_bd_objs $port
}

validate_bd_design
save_bd_design

puts "PORT_COUNT_AFTER=[llength [get_bd_ports -quiet demo_gpio_o]]"

# Verify the important internal connection survived.
set control_net [get_bd_nets -quiet \
    -of_objects [get_bd_pins arc_ctrl_status_0/control_o]]

puts "CONTROL_NET=$control_net"

foreach pin [get_bd_pins -quiet -of_objects $control_net] {
    puts "CONTROL_CONNECTED_PIN=$pin"
}

# Regenerate block-design products.
reset_target all $bd_file
generate_target all $bd_file

puts "ARC_DEMO_GPIO_REMOVE_PASS=1"

close_project
exit 0
