puts "============================================================"
puts "ARC CUSTOM CARRIER - ULTRAZED BOARD PRESET SEARCH"
puts "============================================================"

set all_boards [get_board_parts -quiet *]

puts "TOTAL_BOARD_PARTS=[llength $all_boards]"
puts "------------------------------------------------------------"

set matches {}

foreach bp $all_boards {
    set low [string tolower $bp]

    if {
        [string match "*ultrazed*" $low] ||
        [string match "*uzev*" $low] ||
        [string match "*zu7ev*" $low] ||
        [string match "*avnet*" $low]
    } {
        puts "MATCH=$bp"
        lappend matches $bp
    }
}

puts "------------------------------------------------------------"
puts "MATCH_COUNT=[llength $matches]"

if {[llength $matches] > 0} {
    puts "ARC_ULTRAZED_BOARD_SEARCH_PASS=1"
} else {
    puts "ARC_ULTRAZED_BOARD_SEARCH_PASS=0"
}

exit 0
