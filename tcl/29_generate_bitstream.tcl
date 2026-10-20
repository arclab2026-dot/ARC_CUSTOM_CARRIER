puts "============================================================"
puts "ARC CUSTOM CARRIER - GENERATE BITSTREAM"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set BIT_DIR [file normalize \
    "$ROOT_DIR/build/bitstream"]

set BIT_FILE [file normalize \
    "$BIT_DIR/arc_uzev_custom_registers.bit"]

file mkdir $BIT_DIR

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"
puts "TOP=[get_property TOP [current_fileset]]"

open_run impl_1

write_bitstream \
    -force \
    $BIT_FILE

if {![file exists $BIT_FILE]} {
    puts "ERROR: Bitstream was not created"
    exit 2
}

puts "BIT_FILE=$BIT_FILE"
puts "BIT_SIZE=[file size $BIT_FILE]"
puts "ARC_BITSTREAM_GENERATION_PASS=1"

close_project
exit 0
