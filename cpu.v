module cpu (
    input wire [7:0] data_in,
    input wire clk,
    input wire clear,
    output wire [7:0] data_out,
    output wire enable_ring_counter
);

    wire count_pc, 
         clear_pc, 
         enable_pc, 
         load_accum, 
         enable_accum, 
         load_mar, 
         ce_ram, 
         we_ram, 
         flip_flop,
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

    assign enable_ring_counter = 1'b1;
    assign extended_fetch = 1'b0;

    ring_counter ring_counter(
        .clk(clk),
        .clear(clear),
        .enable(enable_ring_counter), 
        .extended_fetch(extended_fetch),
        .t_state(t_state)
    );

    controller_sequencer controller_sequencer (
        .ring_counter(t_state),
        .instruction(controller_sequencer_input),
        .carry_flag(carry_flag),
        .zero_flag(zero_flag),
        .hlt_clk(hlt_clk),
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
        .load_b_reg(load_b_reg),
        .enable_b_reg(enable_b_reg),
        .load_c_reg(load_c_reg),
        .enable_c_reg(enable_c_reg),
        .load_temp_reg(load_temp_reg),
        .load_mdr_reg(load_mdr_reg),
        .enable_mdr_reg(enable_mdr_reg),
        .load_output_reg(load_output_reg), 
        .load_inst_reg(load_inst_reg),
        .enable_inst_reg(enable_inst_reg), 
        .clear_inst_reg(clear_inst_reg),
        .load_pc(load_pc),
        .extended_fetch(extended_fetch),
        .enable_ring_counter(enable_ring_counter)
    );

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
        .data_in(data_in),
        .data_out(data_out),
        .controller_sequencer_input(controller_sequencer_input),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag)
    );

endmodule