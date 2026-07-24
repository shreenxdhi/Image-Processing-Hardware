# setup.tcl
# Common configuration and paths for OpenROAD flow

set DESIGN_NAME "top"
set NETLIST "../netlist/top_sky130.v"
set SDC_FILE "../constraints/top.sdc"

# PDK Paths (Sky130 HD)
set PDK_ROOT "{path}/.ciel/ciel/sky130/versions/8afc8346a57fe1ab7934ba5a6056ea8b43078e71/sky130A"


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

