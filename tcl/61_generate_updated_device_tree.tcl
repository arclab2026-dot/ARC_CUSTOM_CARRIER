set ROOT [file normalize "."]
set XSA  [file normalize "$ROOT/build/handoff/arc_uzev_sd1_uart_v1_with_bitstream.xsa"]
set REPO [file normalize "$ROOT/../boot_sources/device-tree-xlnx-2022.2"]
set OUT  [file normalize "$ROOT/build/device_tree_sd1_uart/generated"]

puts "===== ARC UPDATED DEVICE TREE ====="
puts "XSA=$XSA"
puts "DT_REPO=$REPO"
puts "OUTPUT=$OUT"

file mkdir $OUT

hsi open_hw_design $XSA
hsi set_repo_path $REPO

set procs [hsi get_cells -filter {IP_TYPE==PROCESSOR}]
puts "PROCESSORS=$procs"

hsi create_sw_design device-tree \
    -os device_tree \
    -proc psu_cortexa53_0

hsi generate_target -dir $OUT

hsi close_hw_design [hsi current_hw_design]

puts "ARC_UPDATED_DEVICE_TREE_PASS=1"
exit
