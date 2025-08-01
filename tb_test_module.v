`timescale 1ns / 1ps
module test_module_tb;

    // Inputs to CPU
    reg clk;
    reg clear;

    // Output from CPU
    wire [7:0] data_out;

    // Instantiate the CPU
    test_module uut (
        .clk(clk),
        .clear(clear),
        .data_in(8'bz),      // data_in unused or tied low since RAM has instructions loaded
        .data_out(data_out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Reset CPU
        clear = 1;
        #10
        clear = 0;

        // clear = 1;
        // #20;


        // Run for a fixed time, then finish
        #100;

        $finish;
    end

    // Monitor signals
    initial begin
        //$monitor("Time: %0t | clk: %b | clear: %b | data_out: %h", $time, clk, clear, data_out);
        $monitor("Time: %0t | bus = %h", $time, uut.datapath.bus);
        //$monitor("Time: %0t | enable pc = %h", $time, uut.enable_pc);
        //$monitor("Time: %0t | count pc = %h", $time, uut.count_pc);
        // $monitor("Time: %0t | clk = %b | clear = %b | enable = %b | extended_fetch = %b | t_state = %b", 
        //  $time, uut.ring_counter.clk, uut.ring_counter.clear, uut.ring_counter.enable, uut.ring_counter.extended_fetch, uut.t_state);
        // $monitor("Time=%0t | hlt_clk=%b count_pc=%b clear_pc=%b enable_pc=%b load_accum=%b enable_accum=%b load_mar=%b ce_ram=%b we_ram=%b sub_mode=%b enable_alu=%b load_b_reg=%b enable_b_reg=%b load_c_reg=%b enable_c_reg=%b load_temp_reg=%b load_mdr_reg=%b enable_mdr_reg=%b load_output_reg=%b load_inst_reg=%b enable_inst_reg=%b clear_inst_reg=%b load_pc=%b extended_fetch=%b enable_ring_counter=%b",
        //      $time, uut.hlt_clk, uut.count_pc, uut.clear_pc, uut.enable_pc, uut.load_accum, uut.enable_accum, uut.load_mar, 
        //      uut.ce_ram, uut.we_ram, uut.sub_mode, uut.enable_alu, uut.load_b_reg, uut.enable_b_reg, uut.load_c_reg, 
        //      uut.enable_c_reg, uut.load_temp_reg, uut.load_mdr_reg, uut.enable_mdr_reg, uut.load_output_reg, 
        //      uut.load_inst_reg, uut.enable_inst_reg, uut.clear_inst_reg, uut.load_pc, uut.extended_fetch, uut.enable_ring_counter);

    end

    // Waveform dump
    // initial begin
    //     $dumpfile("cpu_tb.vcd");
    //     $dumpvars(0, cpu_tb);
    // end

endmodule
