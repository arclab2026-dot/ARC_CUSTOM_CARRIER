puts "========================================"
puts "ARC POWER BUDGET - BASELINE 50C"
puts "========================================"

set checkpoint "build/vivado/arc_uzev_base/arc_uzev_base.runs/impl_1/system_wrapper_routed.dcp"

set report_dir "power_budget/reports"

file mkdir $report_dir

puts "===== OPEN ROUTED CHECKPOINT ====="

open_checkpoint $checkpoint

puts "===== VERIFY FPGA PART ====="

puts "FPGA_PART=[get_property PART [current_design]]"

puts "===== SET THERMAL CONDITIONS ====="

set_operating_conditions \
    -ambient_temp 50 \
    -airflow 250 \
    -heatsink medium \
    -board medium \
    -board_layers 12to15

puts "===== GENERATE POWER REPORT ====="

report_power \
    -file "$report_dir/arc_baseline_power_50c.rpt"

puts "===== GENERATE UTILIZATION REPORT ====="

report_utilization \
    -file "$report_dir/arc_baseline_utilization.rpt"

puts "===== COMPLETE ====="

puts "ARC_BASELINE_POWER_50C_COMPLETE=1"

close_design
