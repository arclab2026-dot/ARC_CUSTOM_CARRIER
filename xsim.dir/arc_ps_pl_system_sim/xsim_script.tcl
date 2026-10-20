set_param project.enableReportConfiguration 0
load_feature core
current_fileset
xsim {arc_ps_pl_system_sim} -autoloadwcfg -tclbatch {sim/24_system_wave_gui.tcl}
