# OpenROAD Signoff Static Timing Analysis Script

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

set_wire_rc -layer met2

# Final parasitic estimation
puts "\[INFO\] Estimating final parasitics..."
estimate_parasitics -global_routing

# Setup timing analysis
puts "\[INFO\] Setup Timing Analysis..."
report_worst_slack -max
report_tns

redirect reports/05_sta_setup_paths.rpt {
  report_checks -path_delay max \
                -fields {slew cap input_pins nets fanout} \
                -format full_clock_expanded \
                -no_line_splits \
                -path_count 10
}

# Hold timing analysis
puts "\[INFO\] Hold Timing Analysis..."
report_worst_slack -min

redirect reports/05_sta_hold_paths.rpt {
  report_checks -path_delay min \
                -fields {slew cap input_pins nets fanout} \
                -format full_clock_expanded \
                -no_line_splits \
                -path_count 10
}

# Design metrics
puts "\[INFO\] Design Area and Power Metrics..."
report_design_area
redirect reports/05_sta_cell_usage.rpt { report_cell_usage }
redirect reports/05_sta_power.rpt { report_power }
report_power

# Summary report
set fp [open "reports/05_sta_summary.rpt" w]
puts $fp "============================================"
puts $fp " SIGNOFF SUMMARY: top"
puts $fp " Technology: Sky130 HD (TT, 25C, 1.8V)"
puts $fp " Clock: 100 MHz (10ns period)"
puts $fp "============================================"
close $fp

redirect -append reports/05_sta_summary.rpt { report_worst_slack -max }
redirect -append reports/05_sta_summary.rpt { report_worst_slack -min }
redirect -append reports/05_sta_summary.rpt { report_tns }
redirect -append reports/05_sta_summary.rpt { report_design_area }
redirect -append reports/05_sta_summary.rpt { report_power }

puts "\[INFO\] STA signoff complete. Reports written to openroad/reports/"
