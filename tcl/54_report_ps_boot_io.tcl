open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr

open_bd_design [get_files system.bd]

set ps [get_bd_cells -quiet zynq_ultra_ps_e_0]

if {[llength $ps] == 0} {
    puts "ERROR: Zynq UltraScale+ PS block not found"
    exit 1
}

puts "===== ARC PS BOOT / IO CONFIGURATION ====="

foreach p [list_property $ps] {
    if {[regexp -nocase {SD0|SD1|UART0|QSPI|MIO} $p]} {
        puts "$p=[get_property $p $ps]"
    }
}

puts "ARC_PS_BOOT_IO_REPORT_PASS=1"
exit
