source "scripts/setup.tcl"

puts "\[INFO\] Reading Tech and Cell LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading Verilog Netlist..."
read_verilog $NETLIST
link_design $DESIGN_NAME

puts "\[INFO\] Performing setup check..."
check_setup -verbose

puts "\[INFO\] Reading SDC constraints..."
read_sdc $SDC_FILE

puts "\[INFO\] Initializing Floorplan..."
initialize_floorplan -utilization 30 \
                     -aspect_ratio 1.0 \
                     -core_space 12.0 \
                     -site unithd

puts "\[INFO\] Generating tracks..."
make_tracks

puts "\[INFO\] Inserting tapcells and endcaps..."
tapcell -distance 14 \
        -tapcell_master $TAP_CELL \
        -endcap_master $ENDCAP_CELL

puts "\[INFO\] Placing I/O pins..."
place_pins -hor_layers met3 -ver_layers met4

puts "\[INFO\] Generating Power Delivery Network..."
add_global_connection -net $VDD_NET -inst_pattern .* -pin_pattern ^VPWR$ -power
add_global_connection -net $VDD_NET -inst_pattern .* -pin_pattern ^VPB$  -power
add_global_connection -net $VDD_NET -inst_pattern .* -pin_pattern ^vccd1$ -power
add_global_connection -net $VSS_NET -inst_pattern .* -pin_pattern ^VGND$ -ground
add_global_connection -net $VSS_NET -inst_pattern .* -pin_pattern ^VNB$  -ground
add_global_connection -net $VSS_NET -inst_pattern .* -pin_pattern ^vssd1$ -ground

set_voltage_domain -name CORE -power $VDD_NET -ground $VSS_NET

define_pdn_grid -name stdcell_grid -starts_with POWER -voltage_domain CORE -pins "met4 met5"

add_pdn_stripe -grid stdcell_grid -layer met1 -width 0.48 -pitch 2.72 -offset 0 -followpins
add_pdn_stripe -grid stdcell_grid -layer met4 -width 1.6 -pitch 27.14 -offset 13.57
add_pdn_stripe -grid stdcell_grid -layer met5 -width 1.6 -pitch 27.14 -offset 13.57

add_pdn_connect -grid stdcell_grid -layers "met1 met4"
add_pdn_connect -grid stdcell_grid -layers "met4 met5"

pdngen

puts "\[INFO\] Writing floorplan DEF..."
write_def results/01_floorplan.def

puts "\[INFO\] Floorplan stage complete."
