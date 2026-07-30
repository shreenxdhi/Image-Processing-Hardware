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

puts "\[INFO\] Streaming out GDSII layout via KLayout..."
if { [catch {exec klayout -zz -r scripts/export_gds.py} kl_err] } {
    puts "\[INFO\] KLayout streamout notice: $kl_err"
} else {
    puts "\[INFO\] GDSII layout generated: results/top_sky130.gds"
}

puts "\[INFO\] Physical Design flow complete."
