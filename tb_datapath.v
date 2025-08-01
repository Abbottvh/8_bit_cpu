`timescale 1ns / 1ps

module tb_datapath;

    reg clk;
    reg clear;
    reg count_pc, clear_pc, enable_pc, load_pc;
    reg load_accum, enable_accum;
    reg load_mar, ce_ram, we_ram;
    reg sub_mode, enable_alu;
    reg load_mdr_reg, enable_mdr_reg;
    reg load_b_reg, enable_b_reg;
    reg load_c_reg, enable_c_reg;
    reg load_temp_reg;
    reg load_output_reg;
    reg load_inst_reg, enable_inst_reg, clear_inst_reg;
    reg enable_input;
    reg flip_flop;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] bus;
    wire zero_flag, carry_flag;

    // Instantiate the datapath
    datapath uut (
        .clk(clk),
        .clear(clear),
        .count_pc(count_pc),
        .clear_pc(clear_pc),
        .enable_pc(enable_pc),
        .load_accum(load_accum),
        .enable_accum(enable_accum),
        .load_mar(load_mar),
        .ce_ram(ce_ram),
        .we_ram(we_ram),
        .flip_flop(flip_flop),
        .sub_mode(sub_mode),
        .enable_alu(enable_alu),
        .load_mdr_reg(load_mdr_reg),
        .enable_mdr_reg(enable_mdr_reg),
        .load_b_reg(load_b_reg),
        .enable_b_reg(enable_b_reg),
        .load_c_reg(load_c_reg),
        .enable_c_reg(enable_c_reg),
        .load_temp_reg(load_temp_reg),
        .load_output_reg(load_output_reg),
        .load_inst_reg(load_inst_reg),
        .enable_inst_reg(enable_inst_reg),
        .clear_inst_reg(clear_inst_reg),
        .load_pc(load_pc),
        .enable_input(enable_input),
        .data_in(data_in),
        .bus(bus),
        .data_out(data_out),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        //$display("Starting Datapath Simulation...");
        $monitor("bus = %h", uut.bus);
        clk = 0;
        clear = 1;

        // Reset all control signals
        count_pc = 0; clear_pc = 0; enable_pc = 0; load_pc = 0;
        load_accum = 0; enable_accum = 0;
        load_mar = 0; ce_ram = 0; we_ram = 0;
        sub_mode = 0; enable_alu = 0;
        load_mdr_reg = 0; enable_mdr_reg = 0;
        load_b_reg = 0; enable_b_reg = 0;
        load_c_reg = 0; enable_c_reg = 0;
        load_temp_reg = 0;
        load_output_reg = 0;
        load_inst_reg = 0; enable_inst_reg = 0; clear_inst_reg = 0;
        enable_input = 0;
        data_in = 8'b00000001;

        #10 clear = 0;

        // Load value into bus via MDR and then into accumulator
        $monitor("Time: %0t | bus = %h | mdr value = %h | multiplexer input = %b", $time, uut.bus_internal, uut.mdr_input, uut.multiplexer_input);
        // data_in = 8'h0A;   // Load 10
        // enable_input = 1;
        // #10;
        // load_b_reg = 1;
        // #10;  // Let the signal settle
        // #10 load_b_reg = 0; enable_input = 0;
        // //$display("bus = %h, b_reg_out = %h", uut.bus, uut.b_reg_out);
        // enable_b_reg = 1;
        // #10 load_accum = 1;
        // #10 load_accum = 0; enable_b_reg = 0;
        // //$display("Accumulator Value: %d", uut.accum_output);

        // // Load value into temp register
        // data_in = 8'h05;   // Load 5
        // enable_input = 1;
        // load_c_reg = 1;
        // #10 load_c_reg = 0; enable_input = 0;
        // //$display("C Value: %d", uut.c_reg_out);
        // enable_c_reg = 1;
        // #10 load_temp_reg = 1;
        // #10 load_temp_reg = 0; enable_c_reg = 0;
        // //$display("Temp Value: %d", uut.temp_output);

        // // ALU operation: ADD and load output
        // enable_alu = 1; 
        // load_output_reg = 1;
        // #10 enable_alu = 0; load_output_reg = 0;

        // // $display("Result: %d", data_out);
        // // $display("Zero flag: %b, Carry flag: %b", zero_flag, carry_flag);

        enable_input = 1;
        load_mar = 1;
        #10
        load_mar = 0;
        ce_ram = 1;
        flip_flop = 0;

        #50

        #20 $finish;
    end

endmodule
