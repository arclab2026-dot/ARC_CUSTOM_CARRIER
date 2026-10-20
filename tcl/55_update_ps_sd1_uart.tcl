open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr

open_bd_design [get_files system.bd]

set ps [get_bd_cells -quiet zynq_ultra_ps_e_0]

if {[llength $ps] == 0} {
    puts "ERROR: Zynq UltraScale+ PS block not found"
    exit 1
}

puts "===== BEFORE ====="
puts "SD0_ENABLE=[get_property CONFIG.PSU__SD0__PERIPHERAL__ENABLE $ps]"
puts "SD0_IO=[get_property CONFIG.PSU__SD0__PERIPHERAL__IO $ps]"
puts "SD1_ENABLE=[get_property CONFIG.PSU__SD1__PERIPHERAL__ENABLE $ps]"
puts "SD1_IO=[get_property CONFIG.PSU__SD1__PERIPHERAL__IO $ps]"
puts "UART0_IO=[get_property CONFIG.PSU__UART0__PERIPHERAL__IO $ps]"
puts "QSPI_ENABLE=[get_property CONFIG.PSU__QSPI__PERIPHERAL__ENABLE $ps]"

set_property -dict [list \
    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
    CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
    CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
    CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
    CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
    CONFIG.PSU__SD1__RESET__ENABLE {0} \
    CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 26 .. 27} \
    CONFIG.PSU__UART0__BAUD_RATE {115200} \
    CONFIG.PSU__UART0__MODEM__ENABLE {0} \
] $ps

validate_bd_design
save_bd_design

puts "===== AFTER ====="
puts "SD0_ENABLE=[get_property CONFIG.PSU__SD0__PERIPHERAL__ENABLE $ps]"
puts "SD0_IO=[get_property CONFIG.PSU__SD0__PERIPHERAL__IO $ps]"
puts "SD1_ENABLE=[get_property CONFIG.PSU__SD1__PERIPHERAL__ENABLE $ps]"
puts "SD1_IO=[get_property CONFIG.PSU__SD1__PERIPHERAL__IO $ps]"
puts "SD1_CD=[get_property CONFIG.PSU__SD1__GRP_CD__IO $ps]"
puts "SD1_WIDTH=[get_property CONFIG.PSU__SD1__DATA_TRANSFER_MODE $ps]"
puts "SD1_SLOT=[get_property CONFIG.PSU__SD1__SLOT_TYPE $ps]"
puts "UART0_IO=[get_property CONFIG.PSU__UART0__PERIPHERAL__IO $ps]"
puts "QSPI_ENABLE=[get_property CONFIG.PSU__QSPI__PERIPHERAL__ENABLE $ps]"

if {
    [get_property CONFIG.PSU__SD1__PERIPHERAL__ENABLE $ps] eq "1" &&
    [get_property CONFIG.PSU__SD1__PERIPHERAL__IO $ps] eq "MIO 46 .. 51" &&
    [get_property CONFIG.PSU__SD1__GRP_CD__IO $ps] eq "MIO 45" &&
    [get_property CONFIG.PSU__UART0__PERIPHERAL__IO $ps] eq "MIO 26 .. 27"
} {
    puts "ARC_PS_SD1_UART_UPDATE_PASS=1"
} else {
    puts "ARC_PS_SD1_UART_UPDATE_PASS=0"
    exit 1
}

exit
