# OpenROAD Routing Script

source "scripts/setup.tcl"

# Read inputs and CTS checkpoint
puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading CTS DEF..."
read_def results/03_cts.def

puts "\[INFO\] Reading SDC..."
read_sdc $SDC_FILE

set_wire_rc -layer met2
set_thread_count 8

# High-fanout net buffering
puts "\[INFO\] Pre-route fanout repair..."
set_max_fanout 200 [current_design]
repair_design

puts "\[INFO\] Re-legalizing after buffer insertion..."
detailed_placement

puts "\[INFO\] Estimating parasitics after fanout repair..."
estimate_parasitics -placement

# Routing layer configuration
puts "\[INFO\] Setting routing layers and adjustments..."
set_routing_layers -signal $MIN_ROUTING_LAYER-$MAX_ROUTING_LAYER \
                   -clock  $MIN_ROUTING_LAYER-$MAX_ROUTING_LAYER

set_global_routing_layer_adjustment met2 0.15
set_global_routing_layer_adjustment met4 0.25

# Global routing
puts "\[INFO\] Running Global Routing..."
global_route -guide_file results/04_route.guide \
             -congestion_iterations 100 \
             -allow_congestion

# Post-route timing repair
puts "\[INFO\] Estimating routed parasitics..."
estimate_parasitics -global_routing

puts "\[INFO\] Repairing post-route timing violations..."
repair_design
repair_timing -hold -hold_margin 0.2

puts "\[INFO\] Final legalization after timing repair..."
detailed_placement

# Antenna diode repair and filler cell insertion
puts "\[INFO\] Performing Antenna Diode Repair..."
repair_antenna $DIODE_CELL -iterations 1

puts "\[INFO\] Inserting Standard Cell Fillers..."
filler_placement $FILLER_CELLS

puts "\[INFO\] Final Legalization post filler/diode placement..."
detailed_placement

# Detailed routing (Fast/Bounded TritonRoute)
puts "\[INFO\] Running Detailed Routing (TritonRoute)..."
detailed_route -bottom_routing_layer $MIN_ROUTING_LAYER \
               -top_routing_layer    $MAX_ROUTING_LAYER \
               -drc_report           reports/04_route_drc.rpt \
               -verbose 1


# Routing reports and verification checks
puts "\[INFO\] Generating routing reports..."
estimate_parasitics -global_routing
redirect reports/04_route_setup_slack.rpt { report_worst_slack -max }
redirect reports/04_route_hold_slack.rpt  { report_worst_slack -min }
redirect reports/04_route_tns.rpt         { report_tns }
redirect reports/04_route_area.rpt        { report_design_area }
redirect reports/04_route_wirelength.rpt  { report_wire_length }

puts "\[INFO\] Performing Antenna and DRC Verification Checks..."
check_antennas -report_file reports/04_route_antennas.rpt

report_worst_slack -max
report_worst_slack -min
report_tns
report_design_area
report_wire_length

# Write routed DEF checkpoint
puts "\[INFO\] Writing Routed DEF..."
write_def results/04_route.def

puts "\[INFO\] Routing complete!"
