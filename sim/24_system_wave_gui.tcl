add_wave /tb_arc_ps_pl_system/clk
add_wave /tb_arc_ps_pl_system/resetn

add_wave /tb_arc_ps_pl_system/awaddr
add_wave /tb_arc_ps_pl_system/awvalid
add_wave /tb_arc_ps_pl_system/wdata
add_wave /tb_arc_ps_pl_system/wvalid

add_wave /tb_arc_ps_pl_system/control_o
add_wave /tb_arc_ps_pl_system/count

add_wave /tb_arc_ps_pl_system/araddr
add_wave /tb_arc_ps_pl_system/arvalid
add_wave /tb_arc_ps_pl_system/rdata
add_wave /tb_arc_ps_pl_system/rvalid

run all
