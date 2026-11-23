create_clock -name clk -period 25.0 [get_ports clk]
set_clock_transition 0.15 [get_clocks clk]
set_clock_uncertainty 0.25 [get_clocks clk]

set_input_delay 5.0 -clock [get_clocks clk] [get_ports reset]
set_output_delay 5.0 -clock [get_clocks clk] [all_outputs]

# Debug-only ALU flag outputs: not timed (they are not real chip interfaces)
set_false_path -to [get_ports {Z N CY OV}]

# Optional, only if reset still fails after the RTL fix (see notes below):
# set_false_path -from [get_ports reset]

set_load 0.0334 [all_outputs]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin Y [get_ports {clk reset}]
set_timing_derate -early 0.95
set_timing_derate -late 1.05

set_max_transition 0.75 [current_design]
set_max_capacitance 0.2 [current_design]
set_max_fanout 40 [current_design]
