# OpenROAD Clock Tree Synthesis Script

source "scripts/setup.tcl"

# Read inputs and placement checkpoint
puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading Placed DEF..."
read_def results/02_place.def

puts "\[INFO\] Reading SDC..."
read_sdc $SDC_FILE

set_wire_rc -layer met2

# Clock Tree Synthesis (TritonCTS)
puts "\[INFO\] Running Clock Tree Synthesis..."
clock_tree_synthesis -root_buf "sky130_fd_sc_hd__clkbuf_16" \
                     -buf_list "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16"

# Legalize clock tree buffers
puts "\[INFO\] Legalizing CTS buffer placement..."
detailed_placement

# Post-CTS parasitics and hold timing repair
puts "\[INFO\] Estimating post-CTS parasitics..."
estimate_parasitics -placement

puts "\[INFO\] Repairing hold timing violations..."
repair_timing -hold \
              -hold_margin 0.3

puts "\[INFO\] Final legalization..."
detailed_placement

# CTS reports
puts "\[INFO\] Generating CTS reports..."
redirect reports/03_cts_summary.rpt { report_cts }
redirect reports/03_cts_skew.rpt { report_clock_skew -digits 3 }

report_clock_skew -digits 3
report_worst_slack -max
report_worst_slack -min

# Write CTS checkpoint
puts "\[INFO\] Writing CTS DEF..."
write_def results/03_cts.def

puts "\[INFO\] Clock Tree Synthesis complete!"
