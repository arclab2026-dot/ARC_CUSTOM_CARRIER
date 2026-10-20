set ROOT [file normalize "."]
set WS   [file normalize "$ROOT/build/vitis_boot_sd1_uart"]
set XSA  [file normalize "$ROOT/build/handoff/arc_uzev_sd1_uart_v1_with_bitstream.xsa"]

puts "===== ARC UPDATED BOOT FIRMWARE ====="
puts "XSA=$XSA"
puts "WORKSPACE=$WS"

file mkdir $WS

setws $WS

platform create \
    -name arc_uzev_sd1_uart_boot \
    -desc "ARC UltraZed SD1 UART boot firmware" \
    -hw $XSA \
    -fsbl-target psu_cortexa53_0

domain create \
    -name standalone \
    -proc psu_cortexa53_0 \
    -os standalone \
    -arch {64-bit}

platform write
platform generate

puts "ARC_UPDATED_BOOT_FIRMWARE_PASS=1"
exit
