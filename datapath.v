// Three-State Buffer
module three_state_buffer (
    input wire [7:0] data_in,
    input wire enable,
    output wire [7:0] data_out
);
    assign data_out = enable ? data_in : 8'bz;
endmodule

// Empty stub for 2-to-1 multiplexer (implement as needed)
module two_to_one_multiplexer(
    input wire [15:0] data_in,
    input wire flip_flop,
    output wire [7:0] data_out
);

    assign data_out = flip_flop ? data_in[7:0] : data_in[15:8];
endmodule

// Datapath
module datapath (
    input wire clk,
    input wire clear,
    input wire count_pc, 
    input wire clear_pc, 
    input wire enable_pc, //get rid of this - not needed
    input wire load_accum, 
    input wire enable_accum, 
    input wire load_mar, 
    input wire ce_ram, 
    input wire we_ram, 
    input wire sub_mode, 
    input wire enable_alu, 
    input wire load_mdr_reg,
    input wire enable_mdr_reg,
    input wire load_b_reg,
    input wire enable_b_reg,
    input wire load_c_reg,
    input wire enable_c_reg,
    input wire load_temp_reg,
    input wire load_output_reg, 
    input wire load_inst_reg,
    input wire enable_inst_reg, 
    input wire clear_inst_reg,
    input wire load_pc,
    input wire flip_flop,
    input wire enable_input,
    input wire [7:0] data_in,
    output wire [7:0] bus,  // if you want to monitor bus outside
    output wire [7:0] data_out,
    output wire zero_flag,
    output wire carry_flag,
    output wire [7:0] controller_sequencer_input
);

    wire [7:0] bus_internal;
    wire [7:0] mar_output;
    wire [7:0] b_reg_out;
    wire [7:0] c_reg_out;
    wire [7:0] mdr_reg_out;
    wire [7:0] temp_output;
    wire [7:0] accum_output;
    wire [7:0] alu_output;
    wire [7:0] address_location;
    wire [7:0] ram_output;
    wire [7:0] mdr_input;
    wire [15:0] multiplexer_input;


    three_state_buffer input_buffer (
        .data_in(data_in),
        .enable(enable_input),
        .data_out(bus_internal)
    );

    cb_register b_register (
        .clk(clk),
        .clear(clear),
        .load(load_b_reg),
        .data_in(bus_internal),
        .data_out(b_reg_out)
    );

    three_state_buffer b_reg_buffer (
        .data_in(b_reg_out),
        .enable(enable_b_reg),
        .data_out(bus_internal)
    );

    cb_register c_register (
        .clk(clk),
        .clear(clear),
        .load(load_c_reg),
        .data_in(bus_internal),
        .data_out(c_reg_out)
    );

    three_state_buffer c_reg_buffer (
        .data_in(c_reg_out),
        .enable(enable_c_reg),
        .data_out(bus_internal)
    );

    cb_register temp_register (
        .clk(clk),
        .clear(clear),
        .load(load_temp_reg),
        .data_in(bus_internal),
        .data_out(temp_output)
    );

    cb_register accumulator (
        .clk(clk),
        .clear(clear),
        .load(load_accum),
        .data_in(bus_internal),
        .data_out(accum_output)
    );

    three_state_buffer accum_buffer (
        .data_in(accum_output),
        .enable(enable_accum),
        .data_out(bus_internal)
    );

    program_counter pc (
        .clk(clk),
        .clear(clear),
        .count(count_pc),
        .load(load_pc),
        .jump_address(bus_internal),
        .address(address_location)
    );

    three_state_buffer pc_buffer (
        .data_in(address_location),
        .enable(enable_pc),
        .data_out(bus_internal)
    );

    eight_bit_adder_subtractor alu (
        .a(accum_output),
        .b(temp_output),
        .sub(sub_mode),
        .sum(alu_output),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag)
    );

    three_state_buffer alu_buffer (
        .data_in(alu_output),
        .enable(enable_alu),
        .data_out(bus_internal)
    );

    cb_register instruction_register (
        .clk(clk),
        .clear(clear_inst_reg),
        .load(load_inst_reg),
        .data_in(bus_internal), // assuming instruction is 4-bit
        .data_out(controller_sequencer_input)
    );

    cb_register mar (
        .clk(clk),
        .clear(clear),
        .load(load_mar),
        .data_in(bus_internal),
        .data_out(mar_output)
    );

    cb_register memory_data_register (
        .clk(clk),
        .clear(clear),
        .load(load_mdr_reg),
        .data_in(mdr_input),
        .data_out(mdr_reg_out)
    );
    
    assign multiplexer_input = {ram_output, bus_internal};

    //flip_flop = 0 selects ram, flip_flop = 1 selects bus
    two_to_one_multiplexer mdr_input_selector (
        .data_in(multiplexer_input),
        .flip_flop(flip_flop),
        .data_out(mdr_input)
    );

    three_state_buffer mdr_register (
        .data_in(mdr_reg_out),
        .enable(enable_mdr_reg),
        .data_out(bus_internal)
    );

    ram memory (
        .clk(clk),                
        .ce(ce_ram),                 
        .we(we_ram),                 
        .addr(mar_output),       
        .data_in(mdr_reg_out),      
        .data_out(ram_output) //COME BACK AND FIX NEED 2-to-1 MULTIPLEXER SO MDR CAN BE LOADED BOTH FROM RAM AND BUS
    );

    cb_register output_register (
        .clk(clk),
        .clear(clear),
        .load(load_output_reg),
        .data_in(bus_internal),
        .data_out(data_out)
    );

    assign bus = bus_internal;

endmodule
