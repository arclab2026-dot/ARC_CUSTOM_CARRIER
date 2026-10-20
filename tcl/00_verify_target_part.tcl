puts "============================================================"
puts "ARC CUSTOM CARRIER - TARGET PART VERIFICATION"
puts "============================================================"

set ARC_PART "xczu7ev-fbvb900-1-e"

set matches [get_parts -quiet $ARC_PART]

if {[llength $matches] != 1} {
    puts "ARC_TARGET_PART_PASS=0"
    puts "ERROR: Could not uniquely locate part $ARC_PART"
    exit 2
}

puts "Requested part : $ARC_PART"
puts "Vivado match   : $matches"

create_project -in_memory -part $ARC_PART

set actual_part [get_property PART [current_project]]

puts "Project part   : $actual_part"

if {$actual_part ne $ARC_PART} {
    puts "ARC_TARGET_PART_PASS=0"
    exit 3
}

puts "ARC_TARGET_PART_PASS=1"
puts "============================================================"

exit 0
