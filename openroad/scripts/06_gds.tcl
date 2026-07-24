# OpenROAD GDSII Layout Streamout Script

source "scripts/setup.tcl"

# Read inputs and routed DEF checkpoint
puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading Routed DEF..."
read_def results/04_route.def

puts "\[INFO\] Reading SDC..."
read_sdc $SDC_FILE

# Write signoff DEF checkpoint
puts "\[INFO\] Writing final signoff DEF..."
write_def results/top_sky130.def

# Stream out GDSII layout
puts "\[INFO\] Exporting GDSII layout to results/top_sky130.gds..."
write_gds results/top_sky130.gds

puts "\[INFO\] GDSII layout generation complete: results/top_sky130.gds"
