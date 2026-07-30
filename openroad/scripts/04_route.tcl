source "scripts/setup.tcl"

puts "\[INFO\] Reading LEFs..."
read_lef $TECH_LEF
read_lef $CELL_LEF

puts "\[INFO\] Reading Liberty..."
read_liberty $LIB_FILE

puts "\[INFO\] Reading CTS DEF..."
read_def results/03_cts.def

puts "\[INFO\] Reading SDC constraints..."
read_sdc $SDC_FILE

set_wire_rc -layer met2

puts "\[INFO\] Buffering high-fanout nets..."
set_max_fanout 30 [current_design]
repair_design

detailed_placement
estimate_parasitics -placement

puts "\[INFO\] Configuring routing layers..."
set_routing_layers -signal $MIN_ROUTING_LAYER-$MAX_ROUTING_LAYER \
                   -clock  $MIN_ROUTING_LAYER-$MAX_ROUTING_LAYER

set_global_routing_layer_adjustment met1 0.05
set_global_routing_layer_adjustment met2 0.05
set_global_routing_layer_adjustment met3 0.05
set_global_routing_layer_adjustment met4 0.05
set_global_routing_layer_adjustment met5 0.05

puts "\[INFO\] Running global routing..."
global_route -guide_file results/04_route.guide \
             -congestion_iterations 50 \
             -allow_congestion

puts "\[INFO\] Inserting filler cells..."
filler_placement $FILLER_CELLS

puts "\[INFO\] Estimating global routing parasitics..."
estimate_parasitics -global_routing
report_worst_slack -max
report_worst_slack -min
report_tns
report_design_area

proc write_report {filename cmd} {
    set fp [open $filename w]
    puts $fp [eval $cmd]
    close $fp
}
write_report reports/04_route_setup_slack.rpt { report_worst_slack -max }
write_report reports/04_route_hold_slack.rpt  { report_worst_slack -min }
write_report reports/04_route_tns.rpt         { report_tns }
write_report reports/04_route_area.rpt        { report_design_area }

puts "\[INFO\] Writing routed DEF..."
write_def results/04_route.def

puts "\[INFO\] Routing stage complete."
