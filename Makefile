PDK_ROOT ?= $(shell find ~/.ciel ~/.volare -name "sky130A" -type d 2>/dev/null | head -n1)
PYTHON ?= $(shell which venv/bin/python3 2>/dev/null || which python3)

.PHONY: all sim synth flow clean help

all: sim synth

sim: python_ref/image.mem
	iverilog -g2012 -o /tmp/sim_top.out rtl/*.v tb/tb_top.sv
	vvp /tmp/sim_top.out

python_ref/image.mem:
	cd python_ref && $(PYTHON) image_to_mem.py

verify: python_ref/image.mem
	$(PYTHON) python_ref/verify.py

synth: python_ref/image.mem
	mkdir -p reports/yosys netlist
	PDK_ROOT=$(PDK_ROOT) yosys scripts/synth_sky130.ys | tee logs/yosys.log

flow:
	cd openroad && bash run_flow.sh

view:
	cd openroad && openroad -gui scripts/view.tcl

clean:
	rm -f /tmp/sim_top.out
	rm -f edge_output.mem gradient_output.mem top.vcd
	rm -f python_ref/image.mem

help:
	@echo "Usage:"
	@echo "  make sim      Run RTL simulation"
	@echo "  make verify   Compare RTL output against Python reference"
	@echo "  make synth    Run Yosys synthesis for Sky130"
	@echo "  make flow     Run OpenROAD physical design flow"
	@echo "  make view     Open layout in OpenROAD GUI"
	@echo "  make clean    Clean simulation outputs"
