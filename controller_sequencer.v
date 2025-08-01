module controller_sequencer (
    input wire [9:0] ring_counter,
    input wire [7:0] instruction,
    input wire carry_flag,
    input wire zero_flag,
    output reg hlt_clk,
    output reg count_pc, 
    output reg clear_pc, 
    output reg enable_pc, 
    output reg load_accum, 
    output reg enable_accum, 
    output reg load_mar, 
    output reg flip_flop,
    output reg ce_ram, 
    output reg we_ram, 
    output reg sub_mode, 
    output reg enable_alu, 
    output reg load_b_reg,
    output reg enable_b_reg,
    output reg load_c_reg,
    output reg enable_c_reg,
    output reg load_temp_reg,
    output reg load_mdr_reg,
    output reg enable_mdr_reg,
    output reg load_output_reg, 
    output reg load_inst_reg,
    output reg enable_inst_reg, 
    output reg clear_inst_reg,
    output reg load_pc,
    output reg extended_fetch,
    output reg enable_ring_counter  // <- New output to control ring counter
);

// Instruction Opcodes
localparam [7:0] 
    LDA        = 8'b00000000,
    STA        = 8'b00000001,
    ADD_B      = 8'b00000010,
    ADD_C      = 8'b00000011,
    SUB_B      = 8'b00000100,
    SUB_C      = 8'b00000101,
    JMP        = 8'b00000110,
    JC         = 8'b00000111,
    JZ         = 8'b00001000,
    OUT        = 8'b00001001,
    HLT        = 8'b00001010,
    MVI_ACCUM  = 8'b00001011,
    MVI_B      = 8'b00001100,
    MVI_C      = 8'b00001101;

always @(*) begin
    // Default control signal values
    hlt_clk = 0;
    count_pc = 0;
    clear_pc = 0;
    enable_pc = 0;
    load_accum = 0;
    enable_accum = 0;
    load_mar = 0;
    ce_ram = 0;
    we_ram = 0;
    sub_mode = 0;
    enable_alu = 0;
    load_b_reg = 0;
    enable_b_reg = 0;
    load_c_reg = 0;
    enable_c_reg = 0;
    load_temp_reg = 0;
    load_mdr_reg = 0;
    enable_mdr_reg = 0;
    load_output_reg = 0;
    load_inst_reg = 0;
    enable_inst_reg = 0;
    clear_inst_reg = 0;
    load_pc = 0;
    extended_fetch = 0;
    flip_flop = 0; //flip_flop = 0 selects ram, flip_flop = 1 selects bus
    enable_ring_counter = 1;  // Default to enabled

    // === ONE-BYTE INSTRUCTIONS ===
    if (^instruction === 1'bx || instruction == ADD_B || instruction == SUB_B || instruction == ADD_C || instruction == SUB_C || instruction == OUT || instruction == HLT) begin
        //$display(">>> ENTERED DEFAULT/FETCH PATH at time %0t, instruction = %b", $time, instruction);
        extended_fetch = 0;

        if (ring_counter[0]) begin
            enable_pc = 1;
            load_mar = 1;
        end 
        else if (ring_counter[1]) begin
            enable_pc = 0;
            load_mar = 0;
            count_pc = 1;
        end 
        else if (ring_counter[2]) begin
            count_pc = 0;
            ce_ram = 1;
            load_mdr_reg = 1;


        end 
        else if (ring_counter[3]) begin
            ce_ram = 0;
            load_mdr_reg = 0;
            enable_mdr_reg = 1;
            load_inst_reg = 1;
        end 
        else if (ring_counter[4]) begin
            enable_mdr_reg = 0;
            load_inst_reg = 0;
            case (instruction)
                ADD_B, SUB_B: begin enable_b_reg = 1; load_temp_reg = 1; end
                ADD_C, SUB_C: begin enable_c_reg = 1; load_temp_reg = 1; end
                OUT: begin enable_accum = 1; load_output_reg = 1; end
                HLT: enable_ring_counter = 0;
            endcase
        end 
        else if (ring_counter[5]) begin
            enable_b_reg = 0;
            enable_c_reg = 0;
            load_temp_reg = 0;
            case (instruction)
                ADD_B, ADD_C: begin enable_alu = 1; load_accum = 1; end
                SUB_B, SUB_C: begin enable_alu = 1; load_accum = 1; sub_mode = 1; end
            endcase
            // Last micro-op for 1-byte instructions
            //enable_ring_counter = 0;
        end
    end

    // === TWO-BYTE INSTRUCTIONS ===
    else if (instruction == LDA || instruction == STA || instruction == JMP || instruction == JC || instruction == JZ ||
             instruction == MVI_ACCUM || instruction == MVI_B || instruction == MVI_C) begin

        extended_fetch = 1;

        if (ring_counter[0]) begin
            enable_pc = 1;
            load_mar = 1;
        end 
        else if (ring_counter[1]) begin
            enable_pc = 0;
            load_mar = 0;
            count_pc = 1;
        end 
        else if (ring_counter[2]) begin
            count_pc = 0;
            ce_ram = 1;
            load_mdr_reg = 1; 
        end 
        else if (ring_counter[3]) begin
            ce_ram = 0;
            load_mdr_reg = 0;
            enable_mdr_reg = 1;
            load_inst_reg = 1;
        end 
        else if (ring_counter[4]) begin
            enable_mdr_reg = 0;
            load_inst_reg = 0;
            enable_pc = 1;
            load_mar = 1;
        end 
        else if (ring_counter[5]) begin
            enable_pc = 0;
            load_mar = 0;
            count_pc = 1;
        end 
        else if (ring_counter[6]) begin
            count_pc = 0;
            ce_ram = 1;
            load_mdr_reg = 1;
        end
        else if (ring_counter[7]) begin
            ce_ram = 0;
            load_mdr_reg = 0;
            case (instruction)
                LDA: begin enable_mdr_reg = 1; load_mar = 1; end
                STA: begin enable_mdr_reg = 1; load_mar = 1; end
                JMP: begin enable_mdr_reg = 1; load_pc = 1; end
                JC: if (carry_flag) begin enable_mdr_reg = 1; load_pc = 1; end
                JZ: if (zero_flag) begin enable_mdr_reg = 1; load_pc = 1; end
                MVI_ACCUM: begin enable_mdr_reg = 1; load_accum = 1; end
                MVI_B: begin enable_mdr_reg = 1; load_b_reg = 1; end
                MVI_C: begin enable_mdr_reg = 1; load_c_reg = 1; end
            endcase
        end 
        else if (ring_counter[8]) begin
            if (instruction == LDA) begin
                enable_mdr_reg = 0; 
                load_mar = 0;
                ce_ram = 1;
                load_mdr_reg = 1;
            end 
            else if (instruction == STA) begin
                enable_mdr_reg = 0; 
                load_mar = 0;
                enable_accum = 1;
                flip_flop = 1; 
                load_mdr_reg = 1;
            end
        end 
        else if (ring_counter[9]) begin
            if (instruction == LDA) begin
                ce_ram = 0;
                load_mdr_reg = 0;
                enable_mdr_reg = 1;
                load_accum = 1;
            end 
            else if (instruction == STA) begin
                enable_accum = 0;
                load_mdr_reg = 0;
                ce_ram = 1;
                we_ram = 1;
                enable_mdr_reg = 1;
            end
            // Last micro-op for 2-byte instructions
            //enable_ring_counter = 0;
        end
    end
end
endmodule
