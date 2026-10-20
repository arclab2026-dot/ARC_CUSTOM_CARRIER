puts "============================================================"
puts "ARC - INSPECT DEMO GPIO PORT"
puts "============================================================"

open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr

set bd_file [lindex [get_files -quiet */system.bd] 0]
open_bd_design $bd_file

set port [get_bd_ports -quiet demo_gpio_o]

puts "PORT_COUNT=[llength $port]"

if {[llength $port] == 1} {
    puts "PORT=$port"

    set nets [get_bd_nets -quiet -of_objects $port]
    puts "CONNECTED_NET_COUNT=[llength $nets]"

    foreach n $nets {
        puts "NET=$n"

        foreach p [get_bd_pins -quiet -of_objects $n] {
            puts "CONNECTED_PIN=$p"
        }
    }
}

close_project
exit
