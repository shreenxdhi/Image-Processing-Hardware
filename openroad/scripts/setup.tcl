# setup.tcl
# Common configuration and paths for OpenROAD flow

set DESIGN_NAME "top"
set NETLIST "../netlist/top_sky130.v"
set SDC_FILE "../constraints/top.sdc"

# PDK Paths (Sky130 HD)
# Use PDK_ROOT env variable if set, otherwise auto-detect from ciel or volare
if { [info exists ::env(PDK_ROOT)] } {
    set PDK_ROOT $::env(PDK_ROOT)
} elseif { [file isdirectory "/home/[exec whoami]/.ciel"] } {
    set PDK_ROOT [exec bash -c {find ~/.ciel/ciel/sky130/versions -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort | tail -n1}]/sky130A
} else {
    set PDK_ROOT [exec bash -c {find ~/.volare/volare/sky130/versions -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort | tail -n1}]/sky130A
}
puts "\[INFO\] PDK_ROOT resolved to: $PDK_ROOT"

set TECH_LEF "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"
set CELL_LEF "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
set LIB_FILE "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
set TRACKS_INFO "$PDK_ROOT/libs.tech/openlane/sky130_fd_sc_hd/tracks.info"

# Routing layers (Met1 is local, Met2-Met5 for routing)
set MIN_ROUTING_LAYER "met1"
set MAX_ROUTING_LAYER "met5"

# Global Nets
set VDD_NET "VDD"
set VSS_NET "VSS"

# Physical Cell Masters (Sky130 HD)
set TAP_CELL "sky130_fd_sc_hd__tapvpwrvgnd_1"
set ENDCAP_CELL "sky130_fd_sc_hd__decap_3"
set DIODE_CELL "sky130_fd_sc_hd__diode_2"
set FILLER_CELLS "sky130_fd_sc_hd__fill_1 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_8"

# Multi-threading configuration (4 physical CPU cores available)
set_thread_count 4
