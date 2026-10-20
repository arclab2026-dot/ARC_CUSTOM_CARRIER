puts "============================================================"
puts "ARC - COMPLETE IMPLEMENTATION BITSTREAM STEP"
puts "============================================================"

open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr

puts "STATUS_BEFORE=[get_property STATUS [get_runs impl_1]]"

launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1

puts "STATUS_AFTER=[get_property STATUS [get_runs impl_1]]"
puts "PROGRESS=[get_property PROGRESS [get_runs impl_1]]"

if {![string match "*Complete*" [get_property STATUS [get_runs impl_1]]]} {
    puts "ARC_IMPL_BITSTREAM_STEP_PASS=0"
    exit 2
}

puts "ARC_IMPL_BITSTREAM_STEP_PASS=1"

close_project
exit 0
