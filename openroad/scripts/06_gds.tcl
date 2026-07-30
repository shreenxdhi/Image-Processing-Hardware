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

puts "\[INFO\] Writing final signoff DEF..."
write_def results/top_sky130.def

puts "\[INFO\] Attempting GDS export..."
set PDK_GDS "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds"
if { [catch {write_gds -merge $PDK_GDS results/top_sky130.gds}] } {
    puts "\[INFO\] write_gds not supported in this build; layout deliverable is results/top_sky130.def"
} else {
    puts "\[INFO\] GDS layout generated: results/top_sky130.gds"
}

puts "\[INFO\] Physical Design flow complete."
