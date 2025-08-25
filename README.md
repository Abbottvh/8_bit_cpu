8-bit computer I coded from scratch after teaching myself the entire system, knowing nothing about how a computer and its parts worked at the start. Has 16 available op-codes, 16-bit memory address capability, 
a basic assembly language, and terminal output capability. I have prewritten a fibonacci sequence program that can be run with the line:
"iverilog -o sim tb_cpu.v 
cpu.v eight_bit_adder_subtractor.v datapath.v controller_sequencer.v cb_
register.v ram.v program_counter.v"
followed by:
"vvp sim"
However, technically anything should be possible to be coded. Enjoy!
