source "scripts/setup.tcl"

puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading Routed DEF..."
read_def results/04_route.def

puts "\[INFO\] Reading SDC constraints..."
read_sdc $SDC_FILE

set_wire_rc -layer met2

puts "\[INFO\] Estimating final parasitics..."
estimate_parasitics -placement

puts "\[INFO\] Setup Timing Analysis..."
report_worst_slack -max
report_tns

puts "\[INFO\] Hold Timing Analysis..."
report_worst_slack -min

puts "\[INFO\] Design Area and Power Metrics..."
report_design_area
report_power

set fp [open "reports/05_sta_summary.rpt" w]
puts $fp "Signoff Summary: top"
puts $fp "Clock: 33 MHz (30 ns period)"
puts $fp [report_worst_slack -max]
puts $fp [report_worst_slack -min]
puts $fp [report_tns]
puts $fp [report_design_area]
puts $fp [report_power]
close $fp

set fp [open "reports/05_sta_power.rpt" w]
puts $fp [report_power]
close $fp

set fp [open "reports/05_sta_cell_usage.rpt" w]
puts $fp [report_cell_usage]
close $fp

puts "\[INFO\] STA signoff complete."
