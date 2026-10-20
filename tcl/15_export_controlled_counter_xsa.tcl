puts "============================================================"
puts "ARC - CONTROLLED COUNTER HARDWARE CHECKPOINT"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

set OUT_DIR [file normalize "$ROOT_DIR/build/handoff"]
set XSA_FILE [file normalize \
    "$OUT_DIR/arc_uzev_ps_pl_counter_presynth.xsa"]

file mkdir $OUT_DIR

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

set bd_file [lindex [get_files -quiet */system.bd] 0]

open_bd_design $bd_file
validate_bd_design
save_bd_design

generate_target all $bd_file

write_hw_platform \
    -fixed \
    -force \
    $XSA_FILE

if {![file exists $XSA_FILE]} {
    puts "ERROR: XSA checkpoint was not created"
    exit 2
}

puts "XSA_FILE=$XSA_FILE"
puts "XSA_SIZE=[file size $XSA_FILE]"
puts "ARC_PS_PL_COUNTER_XSA_PASS=1"

close_project
exit 0
