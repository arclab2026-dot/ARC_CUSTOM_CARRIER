# zcu102_system_constr.xdc — UltraZed-EV Custom Carrier
#
# ZCU102 base board GPIO constraints removed (LEDs, switches not present).
# All ADRV9009-specific constraints are in:
#   projects/adrv9009/zcu102/system_constr.xdc

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]
