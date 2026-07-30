source "scripts/setup.tcl"

puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading Floorplan DEF..."
read_def results/01_floorplan.def

puts "\[INFO\] Reading SDC constraints..."
read_sdc $SDC_FILE

set_wire_rc -layer met2

puts "\[INFO\] Running global placement..."
global_placement -density 0.55

puts "\[INFO\] Estimating parasitics..."
estimate_parasitics -placement

puts "\[INFO\] Running detailed placement..."
detailed_placement

puts "\[INFO\] Running fanout repair..."
repair_design
repair_tie_fanout "sky130_fd_sc_hd__conb_1/HI"
repair_tie_fanout "sky130_fd_sc_hd__conb_1/LO"

detailed_placement

puts "\[INFO\] Generating placement reports..."
set fp [open "reports/02_place_area.rpt" w];        puts $fp [report_design_area];      close $fp
set fp [open "reports/02_place_setup_slack.rpt" w]; puts $fp [report_worst_slack -max]; close $fp
set fp [open "reports/02_place_hold_slack.rpt" w];  puts $fp [report_worst_slack -min]; close $fp
set fp [open "reports/02_place_tns.rpt" w];         puts $fp [report_tns];              close $fp

puts "\[INFO\] Writing placement DEF..."
write_def results/02_place.def

puts "\[INFO\] Placement stage complete."
