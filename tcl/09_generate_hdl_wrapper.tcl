puts "============================================================"
puts "ARC CUSTOM CARRIER - GENERATE HDL WRAPPER"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

open_project $ARC_XPR

puts "PROJECT_PART=[get_property PART [current_project]]"

set bd_file [lindex [get_files -quiet */system.bd] 0]

if {$bd_file eq ""} {
    puts "ERROR: system.bd not found"
    exit 2
}

open_bd_design $bd_file
validate_bd_design
save_bd_design

# Generate HDL/IP output products from the block design.
generate_target all $bd_file

# Generate a top-level HDL wrapper around system.bd.
make_wrapper -files $bd_file -top

set PROJ_DIR [file dirname $ARC_XPR]

set wrappers [glob -nocomplain \
    "$PROJ_DIR/arc_uzev_base.gen/sources_1/bd/system/hdl/system_wrapper.v"]

if {[llength $wrappers] != 1} {
    puts "ERROR: system_wrapper.v not found"
    puts "WRAPPER_COUNT=[llength $wrappers]"
    exit 3
}

set wrapper [lindex $wrappers 0]

add_files -norecurse $wrapper

set_property top system_wrapper [current_fileset]

update_compile_order -fileset sources_1

puts "WRAPPER=$wrapper"
puts "TOP=[get_property TOP [current_fileset]]"

puts "ARC_HDL_WRAPPER_PASS=1"

close_project
exit 0
