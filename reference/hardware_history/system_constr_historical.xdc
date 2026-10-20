
# adrv9009 — UltraZed-EV (XCZU7EV-1FBVB900E) system constraints v3
# Generated from ADRV9009_UltraZed_EV_Pin_Mapping.xlsx Tab 4 (PROPOSED MAPPING)
# All pins verified against SOM schematic PRJUS2SOM10103SchematicPrints.pdf
# All P/N polarity verified from IO_LxxP/IO_LxxN function names
# Zero collisions confirmed by automated check
# Bank 65 @ VCCO_HP_65 = 1.8V | Bank 64 reserved for expansion

# ——————————————————————————————————————————————
# GT Reference Clocks — Quad 227 (Tab 3: verified)
# ——————————————————————————————————————————————
set_property  -dict {PACKAGE_PIN  D10} [get_ports ref_clk0_p]                                          ; ## D04  GBTCLK0_M2C_P  MGTREFCLK0P_227
set_property  -dict {PACKAGE_PIN  D9 } [get_ports ref_clk0_n]                                          ; ## D05  GBTCLK0_M2C_N  MGTREFCLK0N_227
set_property  -dict {PACKAGE_PIN  B10} [get_ports ref_clk1_p]                                          ; ## B20  GBTCLK1_M2C_P  MGTREFCLK1P_227
set_property  -dict {PACKAGE_PIN  B9 } [get_ports ref_clk1_n]                                          ; ## B21  GBTCLK1_M2C_N  MGTREFCLK1N_227

# ——————————————————————————————————————————————
# GT Data Lanes — Quad 227, non-sequential JESD204B mapping (Tab 3: verified)
# ——————————————————————————————————————————————
set_property  -dict {PACKAGE_PIN  C4 } [get_ports rx_data_p[0]]                                        ; ## A02  DP1_M2C_P  MGTHRXP1_227
set_property  -dict {PACKAGE_PIN  C3 } [get_ports rx_data_n[0]]                                        ; ## A03  DP1_M2C_N  MGTHRXN1_227
set_property  -dict {PACKAGE_PIN  D2 } [get_ports rx_data_p[1]]                                        ; ## A06  DP2_M2C_P  MGTHRXP0_227
set_property  -dict {PACKAGE_PIN  D1 } [get_ports rx_data_n[1]]                                        ; ## A07  DP2_M2C_N  MGTHRXN0_227
set_property  -dict {PACKAGE_PIN  B2 } [get_ports rx_data_p[2]]                                        ; ## C06  DP0_M2C_P  MGTHRXP2_227
set_property  -dict {PACKAGE_PIN  B1 } [get_ports rx_data_n[2]]                                        ; ## C07  DP0_M2C_N  MGTHRXN2_227
set_property  -dict {PACKAGE_PIN  A4 } [get_ports rx_data_p[3]]                                        ; ## A10  DP3_M2C_P  MGTHRXP3_227
set_property  -dict {PACKAGE_PIN  A3 } [get_ports rx_data_n[3]]                                        ; ## A11  DP3_M2C_N  MGTHRXN3_227
set_property  -dict {PACKAGE_PIN  D6 } [get_ports tx_data_p[0]]                                        ; ## A22  DP1_C2M_P  MGTHTXP0_227
set_property  -dict {PACKAGE_PIN  D5 } [get_ports tx_data_n[0]]                                        ; ## A23  DP1_C2M_N  MGTHTXN0_227
set_property  -dict {PACKAGE_PIN  C8 } [get_ports tx_data_p[1]]                                        ; ## A26  DP2_C2M_P  MGTHTXP1_227
set_property  -dict {PACKAGE_PIN  C7 } [get_ports tx_data_n[1]]                                        ; ## A27  DP2_C2M_N  MGTHTXN1_227
set_property  -dict {PACKAGE_PIN  B6 } [get_ports tx_data_p[2]]                                        ; ## C02  DP0_C2M_P  MGTHTXP2_227
set_property  -dict {PACKAGE_PIN  B5 } [get_ports tx_data_n[2]]                                        ; ## C03  DP0_C2M_N  MGTHTXN2_227
set_property  -dict {PACKAGE_PIN  A8 } [get_ports tx_data_p[3]]                                        ; ## A30  DP3_C2M_P  MGTHTXP3_227
set_property  -dict {PACKAGE_PIN  A7 } [get_ports tx_data_n[3]]                                        ; ## A31  DP3_C2M_N  MGTHTXN3_227

# ——————————————————————————————————————————————
# JESD204B SYNC and SYSREF — Bank 65 LVDS differential
# P/N verified from IO function names: IO_LxxP = P-side, IO_LxxN = N-side
# ——————————————————————————————————————————————

# sysref (LA00_CC) → HP_DP_33_GC (GC clock-capable) IO_L13P=AH6(P) IO_L13N=AJ6(N)
set_property  -dict {PACKAGE_PIN  AH6  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_p]    ; ## G06  LA00_CC_P  JX1.C31  HP_DP_33_GC_P
set_property  -dict {PACKAGE_PIN  AJ6  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_n]    ; ## G07  LA00_CC_N  JX1.C32  HP_DP_33_GC_N

# sysref_out (LA01_CC) → HP_DP_32_GC (GC clock-capable) IO_L14P=AG6(P) IO_L14N=AG5(N)
set_property  -dict {PACKAGE_PIN  AG6  IOSTANDARD LVDS} [get_ports sysref_out_p]                       ; ## D08  LA01_CC_P  JX1.D32  HP_DP_32_GC_P
set_property  -dict {PACKAGE_PIN  AG5  IOSTANDARD LVDS} [get_ports sysref_out_n]                       ; ## D09  LA01_CC_N  JX1.D33  HP_DP_32_GC_N

# tx_sync (LA02) → HP_DP_30 IO_L18P=AF6(P) IO_L18N=AF5(N)
set_property  -dict {PACKAGE_PIN  AF6  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]   ; ## H07  LA02_P     JX1.B28  HP_DP_30_P
set_property  -dict {PACKAGE_PIN  AF5  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]   ; ## H08  LA02_N     JX1.B29  HP_DP_30_N

# rx_sync (LA03) → HP_DP_46 IO_L23P=AG1(P) IO_L23N=AH1(N)
set_property  -dict {PACKAGE_PIN  AG1  IOSTANDARD LVDS} [get_ports rx_sync_p]                          ; ## G09  LA03_P     JX1.B42  HP_DP_46_P
set_property  -dict {PACKAGE_PIN  AH1  IOSTANDARD LVDS} [get_ports rx_sync_n]                          ; ## G10  LA03_N     JX1.B43  HP_DP_46_N

# tx_sync_1 (LA24) → HP_DP_42 IO_L1P=AH12(P) IO_L1N=AJ12(N)
set_property  -dict {PACKAGE_PIN  AH12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_p] ; ## H28  LA24_P     JX1.B39  HP_DP_42_P
set_property  -dict {PACKAGE_PIN  AJ12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_n] ; ## H29  LA24_N     JX1.B40  HP_DP_42_N

# rx_os_sync (LA25) → HP_DP_26 IO_L9P=AF8(P) IO_L9N=AF7(N)
set_property  -dict {PACKAGE_PIN  AF8  IOSTANDARD LVDS} [get_ports rx_os_sync_p]                       ; ## G27  LA25_P     JX1.B25  HP_DP_26_P
set_property  -dict {PACKAGE_PIN  AF7  IOSTANDARD LVDS} [get_ports rx_os_sync_n]                       ; ## G28  LA25_N     JX1.B26  HP_DP_26_N

# ——————————————————————————————————————————————
# SPI Bus — Bank 65 LVCMOS18 single-ended
# ——————————————————————————————————————————————

# spi_clk (LA07_P) → HP_DP_34_GC_P = AH7
set_property  -dict {PACKAGE_PIN  AH7  IOSTANDARD LVCMOS18} [get_ports spi_clk]                        ; ## H13  LA07_P     JX1.B32  HP_DP_34_GC_P

# spi_mosi (LA07_N) → HP_DP_34_GC_N = AJ7
set_property  -dict {PACKAGE_PIN  AJ7  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                       ; ## H14  LA07_N     JX1.B33  HP_DP_34_GC_N

# spi_miso (LA08_P) → HP_DP_40_P = AH9
set_property  -dict {PACKAGE_PIN  AH9  IOSTANDARD LVCMOS18} [get_ports spi_miso]                       ; ## G12  LA08_P     JX1.D39  HP_DP_40_P

# spi_csn_adrv9009 (LA09_P) → HP_DP_36_P = AJ11
set_property  -dict {PACKAGE_PIN  AJ11 IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9009]               ; ## D14  LA09_P     JX1.D36  HP_DP_36_P

# spi_csn_ad9528 (LA09_N) → HP_DP_36_N = AK11
set_property  -dict {PACKAGE_PIN  AK11 IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]                 ; ## D15  LA09_N     JX1.D37  HP_DP_36_N

# ——————————————————————————————————————————————
# ADRV9009 Control — Bank 65 LVCMOS18 single-ended
# ——————————————————————————————————————————————

# adrv9009_reset_b (LA04_P) → HP_DP_39_P = AF3
set_property  -dict {PACKAGE_PIN  AF3  IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b]               ; ## H10  LA04_P     JX1.A35  HP_DP_39_P

# adrv9009_gpint (LA04_N) → HP_DP_39_N = AF2
set_property  -dict {PACKAGE_PIN  AF2  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint]                 ; ## H11  LA04_N     JX1.A36  HP_DP_39_N

# adrv9009_tx1_enable (LA13_P) → HP_DP_35_GC_P = AG8
set_property  -dict {PACKAGE_PIN  AG8  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable]            ; ## D17  LA13_P     JX1.A31  HP_DP_35_GC_P

# adrv9009_rx1_enable (LA13_N) → HP_DP_35_GC_N = AH8
set_property  -dict {PACKAGE_PIN  AH8  IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable]            ; ## D18  LA13_N     JX1.A32  HP_DP_35_GC_N

# adrv9009_tx2_enable (LA14_P) → HP_DP_45_P = AK3
set_property  -dict {PACKAGE_PIN  AK3  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable]            ; ## C18  LA14_P     JX1.C41  HP_DP_45_P

# adrv9009_rx2_enable (LA14_N) → HP_DP_45_N = AK2
set_property  -dict {PACKAGE_PIN  AK2  IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable]            ; ## C19  LA14_N     JX1.C42  HP_DP_45_N

# adrv9009_test (LA11_P) → HP_DP_43_P = AE9
set_property  -dict {PACKAGE_PIN  AE9  IOSTANDARD LVCMOS18} [get_ports adrv9009_test]                  ; ## H16  LA11_P     JX1.A38  HP_DP_43_P

# ——————————————————————————————————————————————
# AD9528 Control — Bank 65 LVCMOS18 single-ended
# ——————————————————————————————————————————————

# ad9528_reset_b (LA26_P) → HP_DP_47_P = AG4
set_property  -dict {PACKAGE_PIN  AG4  IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]                 ; ## D26  LA26_P     JX1.A41  HP_DP_47_P

# ad9528_sysref_req (LA26_N) → HP_DP_47_N = AG3
set_property  -dict {PACKAGE_PIN  AG3  IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]              ; ## D27  LA26_N     JX1.A42  HP_DP_47_N

# ——————————————————————————————————————————————
# ADRV9009 GPIO — Bank 65 LVCMOS18 single-ended
# ——————————————————————————————————————————————

# gpio_00 (LA15_P) → HP_DP_28_P = AJ5
set_property  -dict {PACKAGE_PIN  AJ5  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00]               ; ## H19  LA15_P     JX1.D28  HP_DP_28_P

# gpio_01 (LA15_N) → HP_DP_28_N = AK5
set_property  -dict {PACKAGE_PIN  AK5  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01]               ; ## H20  LA15_N     JX1.D29  HP_DP_28_N

# gpio_02 (LA16_P) → HP_DP_29_P = AK7
set_property  -dict {PACKAGE_PIN  AK7  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02]               ; ## G18  LA16_P     JX1.C27  HP_DP_29_P

# gpio_03 (LA16_N) → HP_DP_29_N = AK6
set_property  -dict {PACKAGE_PIN  AK6  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03]               ; ## G19  LA16_N     JX1.C28  HP_DP_29_N

# gpio_04 (LA21_P) → HP_DP_27_P = AF12
set_property  -dict {PACKAGE_PIN  AF12 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04]               ; ## H25  LA21_P     JX1.A24  HP_DP_27_P

# gpio_05 (LA21_N) → HP_DP_27_N = AF11
set_property  -dict {PACKAGE_PIN  AF11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05]               ; ## H26  LA21_N     JX1.A25  HP_DP_27_N

# gpio_06 (LA18_CC_P) → HP_DP_31_P = AK9
set_property  -dict {PACKAGE_PIN  AK9  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06]               ; ## C22  LA18_CC_P  JX1.A27  HP_DP_31_P

# gpio_07 (LA18_CC_N) → HP_DP_31_N = AK8
set_property  -dict {PACKAGE_PIN  AK8  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07]               ; ## C23  LA18_CC_N  JX1.A28  HP_DP_31_N

# gpio_08 (LA22_N) → HP_DP_41_N = AH11
set_property  -dict {PACKAGE_PIN  AH11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08]               ; ## G25  LA22_N     JX1.C39  HP_DP_41_N

# gpio_09 (LA19_P) → HP_DP_25_P = AJ10
set_property  -dict {PACKAGE_PIN  AJ10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_09]               ; ## H22  LA19_P     JX1.C24  HP_DP_25_P

# gpio_10 (LA19_N) → HP_DP_25_N = AK10
set_property  -dict {PACKAGE_PIN  AK10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_10]               ; ## H23  LA19_N     JX1.C25  HP_DP_25_N

# gpio_11 (LA20_P) → HP_DP_24_P = AF10
set_property  -dict {PACKAGE_PIN  AF10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_11]               ; ## G21  LA20_P     JX1.D25  HP_DP_24_P

# gpio_12 (LA20_N) → HP_DP_24_N = AG10
set_property  -dict {PACKAGE_PIN  AG10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_12]               ; ## G22  LA20_N     JX1.D26  HP_DP_24_N

# gpio_13 (LA12_N) → HP_DP_37_N = AK4
set_property  -dict {PACKAGE_PIN  AK4  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_13]               ; ## G16  LA12_N     JX1.C36  HP_DP_37_N

# gpio_14 (LA12_P) → HP_DP_37_P = AJ4
set_property  -dict {PACKAGE_PIN  AJ4  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_14]               ; ## G15  LA12_P     JX1.C35  HP_DP_37_P

# gpio_15 (LA22_P) → HP_DP_41_P = AG11
set_property  -dict {PACKAGE_PIN  AG11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_15]               ; ## G24  LA22_P     JX1.C38  HP_DP_41_P

# gpio_16 (LA06_N) → HP_DP_44_N = AH2
set_property  -dict {PACKAGE_PIN  AH2  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_16]               ; ## C11  LA06_N     JX1.D43  HP_DP_44_N

# gpio_17 (LA06_P) → HP_DP_44_P = AH3
set_property  -dict {PACKAGE_PIN  AH3  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_17]               ; ## C10  LA06_P     JX1.D42  HP_DP_44_P

# gpio_18 (LA11_N) → HP_DP_43_N = AE8
set_property  -dict {PACKAGE_PIN  AE8  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_18]               ; ## H17  LA11_N     JX1.A39  HP_DP_43_N

# ——————————————————————————————————————————————
# Clocks
# ——————————————————————————————————————————————
create_clock -name tx_ref_clk     -period  4.00 [get_ports ref_clk0_p]
create_clock -name rx_ref_clk     -period  4.00 [get_ports ref_clk1_p]


# For transceiver output clocks use reference clock
# This will help autoderive the clocks correctly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]

set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]

create_generated_clock -name tx_div_clk     [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gthe4_channel/TXOUTCLK]
create_generated_clock -name rx_div_clk     [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gthe4_channel/RXOUTCLK]
create_generated_clock -name rx_os_div_clk  [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_2/i_gthe4_channel/RXOUTCLK]
