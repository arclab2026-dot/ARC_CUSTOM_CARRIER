set ROOT [file normalize "."]
set WS   [file normalize "$ROOT/build/vitis_boot"]
set XSA  [file normalize "$ROOT/build/handoff/arc_uzev_custom_registers_with_bitstream.xsa"]

puts "============================================================"
puts "ARC - GENERATE FSBL AND PMUFW"
puts "============================================================"
puts "XSA=$XSA"
puts "WORKSPACE=$WS"

setws $WS

platform create \
    -name arc_uzev_boot \
    -desc "ARC UltraZed boot firmware" \
    -hw $XSA \
    -fsbl-target psu_cortexa53_0

domain create \
    -name standalone \
    -proc psu_cortexa53_0 \
    -os standalone \
    -arch {64-bit}

platform write
platform generate

puts "ARC_BOOT_FIRMWARE_GENERATION_PASS=1"
exit
