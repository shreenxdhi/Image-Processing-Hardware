source "scripts/setup.tcl"

puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading Placed DEF..."
read_def results/02_place.def

puts "\[INFO\] Reading SDC constraints..."
read_sdc $SDC_FILE

set_wire_rc -layer met2

puts "\[INFO\] Running clock tree synthesis..."
clock_tree_synthesis -root_buf "sky130_fd_sc_hd__clkbuf_16" \
                     -buf_list "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16"

detailed_placement

puts "\[INFO\] Estimating post-CTS parasitics..."
estimate_parasitics -placement

puts "\[INFO\] Repairing hold timing violations..."
repair_timing -hold -hold_margin 0.3

detailed_placement

report_clock_skew -digits 3
report_worst_slack -max
report_worst_slack -min

puts "\[INFO\] Writing CTS DEF..."
write_def results/03_cts.def

puts "\[INFO\] CTS stage complete."
