puts "============================================================"
puts "ARC CUSTOM CARRIER - CREATE BASE ULTRAZED PROJECT"
puts "============================================================"

set ARC_PART "xczu7ev-fbvb900-1-e"

set ROOT_DIR [file normalize "."]
set PROJ_DIR [file normalize "$ROOT_DIR/build/vivado"]
set PROJ_NAME "arc_uzev_base"

file mkdir $PROJ_DIR

puts "ROOT_DIR = $ROOT_DIR"
puts "PROJ_DIR = $PROJ_DIR"
puts "PROJECT  = $PROJ_NAME"
puts "PART     = $ARC_PART"

# ------------------------------------------------------------
# Create the REAL ARC project using the commercial -1-e device
# ------------------------------------------------------------

create_project \
    $PROJ_NAME \
    "$PROJ_DIR/$PROJ_NAME" \
    -part $ARC_PART \
    -force

puts "PROJECT_PART=[get_property PART [current_project]]"

# ------------------------------------------------------------
# Create Block Design
# ------------------------------------------------------------

create_bd_design "system"

puts "BD_NAME=[current_bd_design]"

# ------------------------------------------------------------
# Instantiate Zynq UltraScale+ MPSoC Processing System
# ------------------------------------------------------------

create_bd_cell \
    -type ip \
    -vlnv xilinx.com:ip:zynq_ultra_ps_e:* \
    zynq_ultra_ps_e_0

puts "PS_CELL=[get_bd_cells zynq_ultra_ps_e_0]"
puts "PS_VLNV=[get_property VLNV [get_bd_cells zynq_ultra_ps_e_0]]"

save_bd_design

# ------------------------------------------------------------
# Record some useful architecture information
# ------------------------------------------------------------

puts "------------------------------------------------------------"
puts "BLOCK DESIGN CELLS"
puts "------------------------------------------------------------"

foreach cell [get_bd_cells] {
    puts "CELL=$cell"
}

puts "------------------------------------------------------------"
puts "PS INTERFACES"
puts "------------------------------------------------------------"

foreach intf [get_bd_intf_pins zynq_ultra_ps_e_0/*] {
    puts "INTF=$intf"
}

puts "------------------------------------------------------------"

puts "ARC_BASE_PROJECT_CREATE_PASS=1"

close_project
exit 0
