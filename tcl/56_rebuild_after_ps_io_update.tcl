open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr

open_bd_design [get_files system.bd]

puts "===== REGENERATE BLOCK DESIGN ====="

validate_bd_design
save_bd_design

generate_target all [get_files system.bd]

puts "===== RESET SYNTHESIS ====="

reset_run synth_1

puts "===== START SYNTHESIS ====="

launch_runs synth_1 -jobs 1
wait_on_run synth_1

set status   [get_property STATUS [get_runs synth_1]]
set progress [get_property PROGRESS [get_runs synth_1]]

puts "SYNTH_STATUS=$status"
puts "SYNTH_PROGRESS=$progress"

if {[string match "*Complete*" $status] && $progress eq "100%"} {
    puts "ARC_PS_IO_REBUILD_SYNTH_PASS=1"
} else {
    puts "ARC_PS_IO_REBUILD_SYNTH_PASS=0"
    exit 1
}

exit
