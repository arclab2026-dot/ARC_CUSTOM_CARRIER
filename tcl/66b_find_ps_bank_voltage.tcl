open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr
open_bd_design [get_files system.bd]

set ps [get_bd_cells -quiet zynq_ultra_ps_e_0]

puts "===== POSSIBLE PS BANK / VOLTAGE PROPERTIES ====="

foreach p [list_property $ps] {
    set v [get_property $p $ps]
    set line "$p=$v"

    if {[regexp -nocase {501|3\.3|3v3|bank|volt|iostandard|io_standard} $line]} {
        puts $line
    }
}

puts "ARC_PS_BANK_SEARCH_PASS=1"
exit
