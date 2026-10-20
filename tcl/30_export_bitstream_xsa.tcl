puts "============================================================"
puts "ARC CUSTOM CARRIER - EXPORT BITSTREAM XSA"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set XSA_FILE [file normalize \
    "$ROOT_DIR/build/handoff/arc_uzev_custom_registers_with_bitstream.xsa"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"
puts "TOP=[get_property TOP [current_fileset]]"

write_hw_platform \
    -fixed \
    -include_bit \
    -force \
    $XSA_FILE

if {![file exists $XSA_FILE]} {
    puts "ERROR: XSA was not created"
    exit 2
}

puts "XSA_FILE=$XSA_FILE"
puts "XSA_SIZE=[file size $XSA_FILE]"
puts "ARC_BITSTREAM_XSA_PASS=1"

close_project
exit 0
