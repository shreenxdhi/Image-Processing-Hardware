# OpenROAD Placement Script

source "scripts/setup.tcl"

# Read inputs and floorplan checkpoint
puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading Floorplan DEF..."
read_def results/01_floorplan.def

puts "\[INFO\] Reading SDC..."
read_sdc $SDC_FILE

set_wire_rc -layer met2

# Global placement
puts "\[INFO\] Running Global Placement..."
global_placement -density 0.55

# Parasitic estimation
puts "\[INFO\] Estimating parasitics..."
estimate_parasitics -placement

# Detailed placement
puts "\[INFO\] Running Detailed Placement..."
detailed_placement

# Post-placement optimization
puts "\[INFO\] Running post-placement fanout & setup optimization..."
repair_design
repair_tie_fanout "sky130_fd_sc_hd__conb_1/HI"
repair_tie_fanout "sky130_fd_sc_hd__conb_1/LO"

puts "\[INFO\] Re-legalizing after optimization..."
detailed_placement

# Placement reports
puts "\[INFO\] Generating placement reports..."
redirect reports/02_place_area.rpt        { report_design_area }
redirect reports/02_place_setup_slack.rpt { report_worst_slack -max }
redirect reports/02_place_hold_slack.rpt  { report_worst_slack -min }
redirect reports/02_place_tns.rpt         { report_tns }

# Write placement checkpoint
puts "\[INFO\] Writing Placed DEF..."
write_def results/02_place.def

puts "\[INFO\] Placement complete!"
