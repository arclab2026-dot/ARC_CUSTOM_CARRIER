puts "============================================================"
puts "ARC CUSTOM CARRIER - FULL PROJECT SYNTHESIS"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"
puts "TOP=[get_property TOP [current_fileset]]"

set bd_file [lindex [get_files -quiet */system.bd] 0]

open_bd_design $bd_file
validate_bd_design
save_bd_design

generate_target all $bd_file
update_compile_order -fileset sources_1

reset_run synth_1

launch_runs synth_1 -jobs 2
wait_on_run synth_1

set status [get_property STATUS [get_runs synth_1]]
set progress [get_property PROGRESS [get_runs synth_1]]

puts "SYNTH_STATUS=$status"
puts "SYNTH_PROGRESS=$progress"

if {![string match "*Complete*" $status]} {
    puts "ARC_FULL_SYNTHESIS_PASS=0"
    exit 2
}

open_run synth_1

report_utilization \
    -file "$ROOT_DIR/evidence/26_SYNTH_UTILIZATION.txt"

puts "ARC_FULL_SYNTHESIS_PASS=1"

close_project
exit 0
