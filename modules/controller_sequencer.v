module controller_sequencer (
    input wire [14:0] ring_counter,
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
    output reg enable_temp,
    output reg load_temp_reg,
    output reg load_mdr_reg,
    output reg enable_mdr_reg,
    output reg select_mdr_output,
    output reg load_output_reg, 
    output reg load_inst_reg,
    output reg enable_inst_reg, 
    output reg clear_inst_reg,
    output reg load_pc,
    output reg [1:0] mode,
    output reg enable_ring_counter 
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
    MVI_C      = 8'b00001101,
    MOV_A_B    = 8'b00001110,
    MOV_A_C    = 8'b00001111;

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
    enable_temp = 0;
    load_temp_reg = 0;
    load_mdr_reg = 0;
    enable_mdr_reg = 0;
    load_output_reg = 0;
    load_inst_reg = 0;
    enable_inst_reg = 0;
    clear_inst_reg = 0;
    load_pc = 0;
    mode = 2'b00;
    flip_flop = 0; //flip_flop = 0 selects ram, flip_flop = 1 selects bus
    select_mdr_output = 1; //selecting lower-byte
    enable_ring_counter = 1;  

    // === ONE-BYTE INSTRUCTIONS ===
    if (^instruction === 1'bx || instruction == ADD_B || instruction == SUB_B || instruction == ADD_C || instruction == SUB_C || instruction == OUT || instruction == HLT || instruction == MOV_A_B || instruction == MOV_A_C) begin
        mode = 2'b00;;

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
                MOV_A_B: begin enable_accum = 1; load_b_reg = 1; end
                MOV_A_C: begin enable_accum = 1; load_c_reg = 1; end
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
    else if (instruction == MVI_ACCUM || instruction == MVI_B || instruction == MVI_C) begin

        mode = 2'b01;

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

    // === THREE-BYTE INSTRUCTIONS ===
    else if (instruction == LDA || instruction == STA || instruction == JMP || instruction == JC || instruction == JZ) begin
            
        mode = 2'b10;

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
            enable_mdr_reg = 1;
            load_temp_reg = 1;
        end 

        else if (ring_counter[8]) begin
            enable_mdr_reg = 0;
            load_temp_reg = 0;
            enable_pc = 1;
            load_mar = 1;
        end 
        else if (ring_counter[9]) begin
            enable_pc = 0;
            load_mar = 0;
            count_pc = 1;
        end 
        else if (ring_counter[10]) begin
            count_pc = 0;
            ce_ram = 1;
            load_mdr_reg = 1;
            select_mdr_output = 0;
        end
        else if (ring_counter[11]) begin
            ce_ram = 0;
            load_mdr_reg = 0;
            select_mdr_output = 0;
            case (instruction)
                LDA: begin enable_mdr_reg = 1; enable_temp = 1; load_mar = 1; end
                STA: begin enable_mdr_reg = 1; enable_temp = 1; load_mar = 1; end
                JMP: begin enable_mdr_reg = 1; enable_temp = 1; load_pc = 1; end
                JC: if (carry_flag) begin enable_mdr_reg = 1; enable_temp = 1; load_pc = 1; end
                JZ: if (zero_flag) begin enable_mdr_reg = 1; enable_temp = 1; load_pc = 1; end
            endcase
        end 
                else if (ring_counter[12]) begin
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

        else if (ring_counter[13]) begin
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
