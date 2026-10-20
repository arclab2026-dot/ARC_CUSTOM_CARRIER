puts "============================================================"
puts "ARC CUSTOM CARRIER - EXPORT PRESYNTH XSA"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set OUT_DIR [file normalize "$ROOT_DIR/build/handoff"]
set XSA_FILE [file normalize \
    "$OUT_DIR/arc_uzev_base_presynth.xsa"]

file mkdir $OUT_DIR

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"
puts "TOP=[get_property TOP [current_fileset]]"

set bd_file [lindex [get_files -quiet */system.bd] 0]

open_bd_design $bd_file
validate_bd_design
save_bd_design

write_hw_platform \
    -fixed \
    -force \
    $XSA_FILE

if {![file exists $XSA_FILE]} {
    puts "ERROR: XSA was not created"
    exit 2
}

puts "XSA_FILE=$XSA_FILE"
puts "XSA_SIZE=[file size $XSA_FILE]"
puts "ARC_PRESYNTH_XSA_PASS=1"

close_project
exit 0
