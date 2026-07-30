source "scripts/setup.tcl"

read_lef $TECH_LEF
read_lef $CELL_LEF
read_liberty $LIB_FILE
read_def results/top_sky130.def
read_sdc $SDC_FILE

puts "\[INFO\] Design loaded. Use the GUI to explore the layout."
puts "\[INFO\] Press Z to zoom fit, click cells to inspect timing."
