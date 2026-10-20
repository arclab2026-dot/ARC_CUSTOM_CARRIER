puts "============================================================"
puts "ARC CUSTOM CARRIER - PRE-BITSTREAM DRC"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set ARC_XPR [file normalize \
    "$ROOT_DIR/build/vivado/arc_uzev_base/arc_uzev_base.xpr"]

open_project $ARC_XPR
open_run impl_1

puts "PROJECT_PART=[get_property PART [current_project]]"
puts "TOP=[get_property TOP [current_fileset]]"

report_drc \
    -file "$ROOT_DIR/evidence/28_PRE_BITSTREAM_DRC.txt"

puts "------------------------------------------------------------"
puts "TOP-LEVEL PORTS"
puts "------------------------------------------------------------"

foreach p [get_ports -quiet *] {
    puts "PORT=$p PACKAGE_PIN=[get_property PACKAGE_PIN $p] IOSTANDARD=[get_property IOSTANDARD $p]"
}

set errors [get_drc_violations -quiet -filter {SEVERITY == Error}]
set criticals [get_drc_violations -quiet -filter {SEVERITY == "Critical Warning"}]

puts "DRC_ERROR_COUNT=[llength $errors]"
puts "DRC_CRITICAL_WARNING_COUNT=[llength $criticals]"

foreach v $errors {
    puts "DRC_ERROR=$v"
}

foreach v $criticals {
    puts "DRC_CRITICAL=$v"
}

if {[llength $errors] == 0} {
    puts "ARC_PRE_BITSTREAM_DRC_PASS=1"
} else {
    puts "ARC_PRE_BITSTREAM_DRC_PASS=0"
    exit 2
}

close_project
exit 0
