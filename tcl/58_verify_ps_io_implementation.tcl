open_project build/vivado/arc_uzev_base/arc_uzev_base.xpr
open_run impl_1

file mkdir evidence

puts "===== TIMING ====="

report_timing_summary \
    -file evidence/58_TIMING_SUMMARY.txt

set timing_text [report_timing_summary -return_string]

if {[string match "*All user specified timing constraints are met*" $timing_text]} {
    puts "ARC_TIMING_PASS=1"
} else {
    puts "ARC_TIMING_PASS=0"
}

puts "===== DRC ====="

set drc_text [report_drc -return_string]

set error_count 0
set critical_count 0

foreach line [split $drc_text "\n"] {
    if {[regexp {^ERROR} $line]} {
        incr error_count
    }

    if {[regexp {^CRITICAL WARNING} $line]} {
        incr critical_count
    }
}

report_drc \
    -file evidence/58_DRC_REPORT.txt

puts "DRC_ERROR_COUNT=$error_count"
puts "DRC_CRITICAL_WARNING_COUNT=$critical_count"

if {$error_count == 0 && $critical_count == 0} {
    puts "ARC_DRC_PASS=1"
} else {
    puts "ARC_DRC_PASS=0"
}

if {
    [string match "*All user specified timing constraints are met*" $timing_text] &&
    $error_count == 0 &&
    $critical_count == 0
} {
    puts "ARC_PS_IO_IMPLEMENTATION_VERIFY_PASS=1"
} else {
    puts "ARC_PS_IO_IMPLEMENTATION_VERIFY_PASS=0"
}

exit
