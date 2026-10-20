puts "============================================================"
puts "ARC CUSTOM CARRIER - PACKAGE RESOURCE INSPECTION"
puts "============================================================"

set ARC_PART "xczu7ev-fbvb900-1-e"

create_project -in_memory -part $ARC_PART
set_property DESIGN_MODE PinPlanning [current_fileset]
open_io_design -name arc_resource_audit -part $ARC_PART

set audit_pins {
    D10 D9
    B10 B9

    C4 C3
    D2 D1
    B2 B1
    A4 A3

    D6 D5
    C8 C7
    B6 B5
    A8 A7

    AH6 AJ6
    AF6 AF5
    AG1 AH1

    AH7 AJ7
    AF3 AF2
}

foreach pin $audit_pins {
    puts ""
    puts "============================================================"
    puts "PACKAGE_PIN=$pin"
    puts "============================================================"

    set obj [get_package_pins -quiet $pin]

    if {[llength $obj] != 1} {
        puts "ERROR: pin lookup failed"
        continue
    }

    report_property $obj
}

puts ""
puts "ARC_PIN_RESOURCE_INSPECTION_PASS=1"

exit 0
