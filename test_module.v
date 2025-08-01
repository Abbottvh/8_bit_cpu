module test_module (
    input wire [7:0] data_in,
    input wire clk,
    input wire clear,
    output wire [7:0] data_out
);

    wire count_pc, 
         clear_pc, 
         enable_pc, 
         load_accum, 
         enable_accum, 
         load_mar, 
         ce_ram, 
         we_ram, 
         sub_mode, 
         enable_alu, 
         load_mdr_reg,
         enable_mdr_reg,
         load_b_reg,
         enable_b_reg,
         load_c_reg,
         enable_c_reg,
         load_temp_reg,
         load_output_reg, 
         load_inst_reg,
         enable_inst_reg, 
         clear_inst_reg,
         load_pc,
         zero_flag,
         carry_flag,
         extended_fetch,
         internal_enable_ring_counter;
         //enable_ring_counter;
  
    wire [7:0] controller_sequencer_input;
    wire [9:0] t_state;

    assign data_out = 8'b1;
    assign enable_pc = 1'b1;
    assign count_pc = 1'b1;

        datapath datapath (
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
        .data_in(data_in),
        .data_out(data_out),
        .controller_sequencer_input(controller_sequencer_input),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag)
    );

endmodule