# Timing constraints for Streaming Image Processing Accelerator (100 MHz, 10ns period)

# Clock definition
create_clock \
    -name clk \
    -period 10.000 \
    [get_ports clk]

# Clock uncertainty and transition
set_clock_uncertainty 0.10 [get_clocks clk]
set_clock_transition 0.10 [get_clocks clk]

# Input and output delays
set_input_delay 1.00 \
    -clock clk \
    [get_ports rst]

set_output_delay 1.00 \
    -clock clk \
    [get_ports edge_valid]

set_output_delay 1.00 \
    -clock clk \
    [get_ports {edge_pixel[*]}]

# False paths
set_false_path \
    -from [get_ports rst]

# Design limits
set_max_fanout 16 [current_design]
set_max_transition 0.75 [current_design]
set_max_capacitance 0.20 [current_design]
