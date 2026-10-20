set ROOT [file normalize "."]
set FW   [file normalize "$ROOT/build/jtag_bringup"]

puts "===== ARC JTAG STAGE-1 BRING-UP ====="

connect

puts "===== INITIAL TARGETS ====="
targets

# JTAG security gates are enabled by default on ZynqMP.
# Select PSU and expose DAP / PL TAP / PMU.
targets -set -filter {name =~ "PSU"}
mwr 0xffca0038 0x1ff
after 500

puts "===== TARGETS AFTER SECURITY GATE OPEN ====="
targets

# PMU firmware MUST run before FSBL in JTAG boot mode.
targets -set -filter {name =~ "MicroBlaze PMU"}
puts "DOWNLOADING_PMUFW=$FW/pmufw.elf"
dow "$FW/pmufw.elf"
con
after 500

# Release/reset A53-0 and run FSBL.
targets -set -filter {name =~ "Cortex-A53 #0"}
rst -processor

puts "DOWNLOADING_FSBL=$FW/fsbl.elf"
dow "$FW/fsbl.elf"
con

puts "===== FSBL RUNNING ====="
puts "Watch UART0 at 115200 baud."
puts "ARC_JTAG_STAGE1_STARTED=1"

after 5000
stop

puts "ARC_JTAG_STAGE1_STOPPED_AFTER_5S=1"
exit
