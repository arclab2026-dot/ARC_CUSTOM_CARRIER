puts "============================================================"
puts "ARC CUSTOM CARRIER - AVNET BDF VERIFICATION"
puts "============================================================"

set BDF_ROOT [file normalize "reference/vendor/avnet_bdf"]

puts "BDF_ROOT=$BDF_ROOT"

set_param board.repoPaths [list $BDF_ROOT]

set matches [get_board_parts -quiet *ultrazed*]

puts "MATCH_COUNT=[llength $matches]"

foreach bp $matches {
    puts "BOARD_PART=$bp"
    puts "BOARD_FPGA=[get_property PART_NAME $bp]"
}

if {[llength $matches] > 0} {
    puts "ARC_AVNET_BDF_PASS=1"
} else {
    puts "ARC_AVNET_BDF_PASS=0"
}

exit 0
