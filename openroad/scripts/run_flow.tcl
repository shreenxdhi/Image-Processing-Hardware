# Master Orchestration Script for image_pipeline Physical Design
# This script runs the complete RTL-to-DEF flow in sequence

puts "============================================"
puts " image_pipeline: OpenROAD Physical Design"
puts " Technology: Sky130 HD"
puts " Clock: 100 MHz"
puts "============================================"
puts ""

set start_time [clock seconds]

# ---------------------------------------------------------------
# Stage 1: Floorplan
# ---------------------------------------------------------------
puts "\[FLOW\] ===== Stage 1/5: FLOORPLAN ====="
source scripts/01_floorplan.tcl
puts ""

# ---------------------------------------------------------------
# Stage 2: Placement
# ---------------------------------------------------------------
puts "\[FLOW\] ===== Stage 2/5: PLACEMENT ====="
source scripts/02_place.tcl
puts ""

# ---------------------------------------------------------------
# Stage 3: Clock Tree Synthesis
# ---------------------------------------------------------------
puts "\[FLOW\] ===== Stage 3/5: CTS ====="
source scripts/03_cts.tcl
puts ""

# ---------------------------------------------------------------
# Stage 4: Routing
# ---------------------------------------------------------------
puts "\[FLOW\] ===== Stage 4/5: ROUTING ====="
source scripts/04_route.tcl
puts ""

# ---------------------------------------------------------------
# Stage 5: Signoff STA
# ---------------------------------------------------------------
puts "\[FLOW\] ===== Stage 5/5: STA SIGNOFF ====="
source scripts/05_sta.tcl
puts ""

# ---------------------------------------------------------------
# Flow Summary
# ---------------------------------------------------------------
set end_time [clock seconds]
set elapsed [expr {$end_time - $start_time}]
set minutes [expr {$elapsed / 60}]
set seconds [expr {$elapsed % 60}]

puts "============================================"
puts " FLOW COMPLETE"
puts " Total Runtime: ${minutes}m ${seconds}s"
puts ""
puts " Checkpoints:"
puts "   results/01_floorplan.def"
puts "   results/02_place.def"
puts "   results/03_cts.def"
puts "   results/04_route.def"
puts ""
puts " Reports:"
puts "   reports/05_sta_summary.rpt"
puts "   reports/05_sta_setup_paths.rpt"
puts "   reports/05_sta_hold_paths.rpt"
puts "   reports/05_sta_power.rpt"
puts "   reports/05_sta_cell_usage.rpt"
puts "============================================"

exit
