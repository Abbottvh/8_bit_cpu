`timescale 1ns / 1ps

module controller_sequencer_tb;

    // Inputs
    reg [9:0] ring_counter;
    reg [7:0] instruction;
    reg carry_flag;
    reg zero_flag;

    // Outputs
    wire hlt_clk;
    wire count_pc;
    wire clear_pc;
    wire enable_pc;
    wire load_accum;
    wire enable_accum;
    wire load_mar;
    wire ce_ram;
    wire we_ram;
    wire sub_mode;
    wire enable_alu;
    wire load_b_reg;
    wire enable_b_reg;
    wire load_c_reg;
    wire enable_c_reg;
    wire load_temp_reg;
    wire load_mdr_reg;
    wire enable_mdr_reg;
    wire load_output_reg;
    wire load_inst_reg;
    wire enable_inst_reg;
    wire clear_inst_reg;
    wire load_pc;
    wire extended_fetch;
    wire enable_ring_counter;

    // Instantiate the Unit Under Test (UUT)
    controller_sequencer uut (
        .ring_counter(ring_counter),
        .instruction(instruction),
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

    integer i;

    // Task to step through each ring_counter bit
    task step_through_ring;
        input [7:0] instr;
        input [8*32-1:0] instr_name; // simulate a string
        begin
            $display("=== Testing Instruction: %s (0x%0h) ===", instr_name, instr);
            $display("enable ring counter value:", enable_ring_counter);
            instruction = instr;
            for (i = 0; i < 10; i = i + 1) begin
                ring_counter = 10'b1 << i;
                #10;
                $display("ring_counter[%0d]: enable_pc=%b, load_mar=%b, ce_ram=%b, load_accum=%b, hlt_clk=%b, load_b_reg=%b, enable_alu=%b, sub_mode=%b, load_pc=%b",
                         i, enable_pc, load_mar, ce_ram, load_accum, hlt_clk, load_b_reg, enable_alu, sub_mode, load_pc);
            end
            $display("");
        end
    endtask

    initial begin
        // Initialize
        carry_flag = 0;
        zero_flag  = 0;
        ring_counter = 0;
        instruction = 0;

        #10;

        // Test one-byte instructions
        step_through_ring(8'b00000010, "ADD_B");
        step_through_ring(8'b00000101, "SUB_C");
        step_through_ring(8'b00001001, "OUT");
        step_through_ring(8'b00001010, "HLT");

        // Test two-byte instructions
        step_through_ring(8'b00000000, "LDA");
        step_through_ring(8'b00000001, "STA");
        step_through_ring(8'b00000110, "JMP");

        // Conditional jump tests
        carry_flag = 1;
        step_through_ring(8'b00000111, "JC (carry=1)");
        carry_flag = 0;
        step_through_ring(8'b00000111, "JC (carry=0)");

        zero_flag = 1;
        step_through_ring(8'b00001000, "JZ (zero=1)");
        zero_flag = 0;
        step_through_ring(8'b00001000, "JZ (zero=0)");

        $display("Test completed.");
        $stop;
    end

endmodule
