open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr
open_bd_design [get_files system.bd]

set ps [get_bd_cells -quiet zynq_ultra_ps_e_0]

puts "===== PS BANK / VOLTAGE SETTINGS ====="

foreach p [list_property $ps] {
    if {[regexp -nocase {BANK.*VOLT|VOLT.*BANK|501|MIO.*VOLT} $p]} {
        puts "$p=[get_property $p $ps]"
    }
}

puts "===== UART / SD CHECK ====="
puts "UART0_IO=[get_property CONFIG.PSU__UART0__PERIPHERAL__IO $ps]"
puts "SD1_IO=[get_property CONFIG.PSU__SD1__PERIPHERAL__IO $ps]"
puts "SD1_CD=[get_property CONFIG.PSU__SD1__GRP_CD__IO $ps]"

puts "ARC_PS_BANK_REPORT_PASS=1"
exit
