open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr

file mkdir build/bitstream
file mkdir build/handoff

puts "===== COMPLETE BITSTREAM RUN ====="

launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1

set status   [get_property STATUS [get_runs impl_1]]
set progress [get_property PROGRESS [get_runs impl_1]]

puts "IMPL_STATUS=$status"
puts "IMPL_PROGRESS=$progress"

if {![string match "*Complete*" $status] || $progress ne "100%"} {
    puts "ARC_PS_IO_BITSTREAM_RUN_PASS=0"
    exit 1
}

puts "ARC_PS_IO_BITSTREAM_RUN_PASS=1"

open_run impl_1

set bitfile [file normalize "build/bitstream/arc_uzev_sd1_uart_v1.bit"]

write_bitstream \
    -force \
    $bitfile

puts "BIT_FILE=$bitfile"
puts "BIT_SIZE=[file size $bitfile]"

set xsafile [file normalize "build/handoff/arc_uzev_sd1_uart_v1_with_bitstream.xsa"]

write_hw_platform \
    -fixed \
    -include_bit \
    -force \
    -file $xsafile

puts "XSA_FILE=$xsafile"
puts "XSA_SIZE=[file size $xsafile]"

if {[file exists $bitfile] && [file exists $xsafile]} {
    puts "ARC_PS_IO_BITSTREAM_XSA_PASS=1"
} else {
    puts "ARC_PS_IO_BITSTREAM_XSA_PASS=0"
    exit 1
}

exit
