puts "============================================================"
puts "ARC CUSTOM CARRIER - FPGA IMPLEMENTATION"
puts "============================================================"

set ROOT_DIR [file normalize "."]

set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"
puts "TOP=[get_property TOP [current_fileset]]"

set synth_status [get_property STATUS [get_runs synth_1]]
puts "SYNTH_STATUS=$synth_status"

if {![string match "*Complete*" $synth_status]} {
    puts "ERROR: synthesis is not complete"
    exit 2
}

reset_run impl_1

# Place and route only.
# We are NOT generating the bitstream yet.
launch_runs impl_1 -to_step route_design -jobs 1
wait_on_run impl_1

set impl_status [get_property STATUS [get_runs impl_1]]
set impl_progress [get_property PROGRESS [get_runs impl_1]]

puts "IMPL_STATUS=$impl_status"
puts "IMPL_PROGRESS=$impl_progress"

if {![string match "*Complete*" $impl_status]} {
    puts "ARC_FULL_IMPLEMENTATION_PASS=0"
    exit 3
}

open_run impl_1

report_timing_summary \
    -file "$ROOT_DIR/evidence/27_TIMING_SUMMARY.txt"

report_utilization \
    -file "$ROOT_DIR/evidence/27_IMPLEMENTED_UTILIZATION.txt"

puts "ARC_FULL_IMPLEMENTATION_PASS=1"

close_project
exit 0
