puts "============================================================"
puts "ARC CUSTOM CARRIER - CAPTURE AVNET ULTRAZED PS PRESET"
puts "============================================================"

set ROOT_DIR [file normalize "."]
set BDF_ROOT [file normalize "$ROOT_DIR/reference/vendor/avnet_bdf"]

set REF_PART  "xczu7ev-fbvb900-1-i"
set BOARD_PART "avnet-tria:ultrazed_7ev_cc:part0:1.6"

set PROJ_DIR  [file normalize "$ROOT_DIR/build/avnet_reference"]
set PROJ_NAME "avnet_uzev_reference"

file mkdir $PROJ_DIR

# Tell Vivado where the Avnet board definitions are.
set_param board.repoPaths [list $BDF_ROOT]

puts "REFERENCE_PART=$REF_PART"
puts "BOARD_PART=$BOARD_PART"

# ------------------------------------------------------------
# IMPORTANT:
# This is a REFERENCE project only.
# Our real ARC project remains xczu7ev-fbvb900-1-e.
# ------------------------------------------------------------

create_project \
    $PROJ_NAME \
    "$PROJ_DIR/$PROJ_NAME" \
    -part $REF_PART \
    -force

set_property board_part $BOARD_PART [current_project]

puts "PROJECT_BOARD_PART=[get_property BOARD_PART [current_project]]"
puts "PROJECT_PART=[get_property PART [current_project]]"

create_bd_design "system"

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:zynq_ultra_ps_e:* \
    zynq_ultra_ps_e_0

# Apply Avnet's UltraZed board preset.
apply_bd_automation \
    -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
    -config {apply_board_preset "1"} \
    [get_bd_cells zynq_ultra_ps_e_0]

save_bd_design

set ps [get_bd_cells zynq_ultra_ps_e_0]

# ------------------------------------------------------------
# Export every CONFIG property so we can inspect the preset.
# ------------------------------------------------------------

set OUT_FILE [file normalize \
    "$ROOT_DIR/evidence/06_AVNET_PS_PRESET_PROPERTIES.txt"]

set fh [open $OUT_FILE w]

puts $fh "ARC AVNET ULTRAZED PS PRESET"
puts $fh "REFERENCE_PART=$REF_PART"
puts $fh "BOARD_PART=$BOARD_PART"
puts $fh ""

foreach p [lsort [list_property $ps]] {
    if {[string match "CONFIG.*" $p]} {
        puts $fh "$p=[get_property $p $ps]"
    }
}

close $fh

puts "PRESET_DUMP=$OUT_FILE"

puts "------------------------------------------------------------"
puts "ENABLED PS INTERFACES"
puts "------------------------------------------------------------"

foreach intf [get_bd_intf_pins $ps/*] {
    puts "INTF=$intf"
}

puts "------------------------------------------------------------"

validate_bd_design

puts "ARC_AVNET_PS_PRESET_CAPTURE_PASS=1"

close_project
exit 0
