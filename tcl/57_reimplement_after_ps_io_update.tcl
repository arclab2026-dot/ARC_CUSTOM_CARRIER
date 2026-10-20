open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr

puts "===== RESET IMPLEMENTATION ====="
reset_run impl_1

puts "===== START IMPLEMENTATION ====="
launch_runs impl_1 -to_step route_design -jobs 1
wait_on_run impl_1

set status   [get_property STATUS [get_runs impl_1]]
set progress [get_property PROGRESS [get_runs impl_1]]

puts "IMPL_STATUS=$status"
puts "IMPL_PROGRESS=$progress"

if {[string match "*Complete*" $status] && $progress eq "100%"} {
    puts "ARC_PS_IO_REIMPLEMENT_PASS=1"
} else {
    puts "ARC_PS_IO_REIMPLEMENT_PASS=0"
    exit 1
}

exit
