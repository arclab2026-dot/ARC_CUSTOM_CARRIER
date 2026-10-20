puts "============================================================"
puts "ARC CUSTOM CARRIER - HISTORICAL XDC PIN AUDIT V2"
puts "============================================================"

set ARC_PART "xczu7ev-fbvb900-1-e"
set XDC_FILE [file normalize \
    "reference/hardware_history/system_constr_historical.xdc"]

create_project -in_memory -part $ARC_PART

# Open a real I/O planning design so package-pin objects exist.
set_property DESIGN_MODE PinPlanning [current_fileset]
open_io_design -name arc_io_audit -part $ARC_PART

puts "Part : $ARC_PART"
puts "XDC  : $XDC_FILE"

set total_pkg_pins [llength [get_package_pins -quiet *]]
puts "Vivado package pin objects: $total_pkg_pins"

if {$total_pkg_pins == 0} {
    puts "ARC_PIN_DB_READY=0"
    puts "ARC_XDC_PACKAGE_PIN_PASS=0"
    exit 10
}

puts "ARC_PIN_DB_READY=1"

set fh [open $XDC_FILE r]
set text [read $fh]
close $fh

set pins {}

foreach line [split $text "\n"] {
    if {[regexp {PACKAGE_PIN[[:space:]]+([A-Za-z]+[0-9]+)} $line -> pin]} {
        lappend pins $pin
    }
}

set pins [lsort -unique $pins]

puts "Unique PACKAGE_PIN entries: [llength $pins]"
puts "------------------------------------------------------------"

set failures 0
set passes 0

foreach pin $pins {
    set obj [get_package_pins -quiet $pin]

    if {[llength $obj] != 1} {
        puts "FAIL  $pin"
        incr failures
    } else {
        puts "PASS  $pin"
        incr passes
    }
}

puts "------------------------------------------------------------"
puts "Passes  : $passes"
puts "Failures: $failures"

if {$failures == 0 && $passes == [llength $pins]} {
    puts "ARC_XDC_PACKAGE_PIN_PASS=1"
    exit 0
} else {
    puts "ARC_XDC_PACKAGE_PIN_PASS=0"
    exit 2
}
