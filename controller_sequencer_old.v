module controller_sequencer (
    input wire [9:0] ring_counter,
    input wire [7:0] instruction,
    input wire carry_flag,
    input wire zero_flag,
    output wire hlt_clk,
    output wire count_pc, 
    output wire clear_pc, 
    output wire enable_pc, 
    output wire load_accum, 
    output wire enable_accum, 
    output wire load_mar, 
    output wire ce_ram, 
    output wire we_ram, 
    output wire sub_mode, 
    output wire enable_alu, 
    output wire load_b_reg,
    output wire enable_b_reg,
    output wire load_c_reg,
    output wire enable_c_reg,
    output wire load_temp_reg,
    output wire load_mdr_reg,
    output wire enable_mdr_reg,
    output wire load_output_reg, 
    output wire load_inst_reg,
    output wire enable_inst_reg, 
    output wire clear_inst_reg,
    output wire load_pc,
    output wire extended_fetch

);
localparam LDA        = 4'b00000000,
           STA        = 4'b00000001,
           ADD_B      = 4'b00000010,
           ADD_C      = 4'b00000011,
           SUB_B      = 4'b00000100,
           SUB_C      = 4'b00000101,
           JMP        = 4'b00000110,
           JC         = 4'b00000111,
           JZ         = 4'b00001000,
           OUT        = 4'b00001001,
           HLT        = 4'b00001010,
           MVI_ACCUM  = 4'b00001011,
           MVI_B      = 4'b00001100,
           MVI_C      = 4'b00001101;
always @(*) begin
    // Default values
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
//1-byte Instructions
    //ADD B
    //ADD C
    //SUB B
    //SUB C
    //OUT
    //HLT
if (^instruction === 1'bx || instruction == ADD_B || instruction == SUB_B || instruction == ADD_C || instruction == SUB_C || instruction == OUT || instruction == HLT) begin
    $display(">>> ENTERED DEFAULT/FETCH PATH at time %0t, instruction = %b", $time, instruction);

    extended_fetch = 0

    if (ring_counter[0] == 1)
        enable_pc = 1
        load_mar = 1
    
    else if (ring_counter[1] == 1)
        count_pc = 1

    else if (ring_counter[2] == 1)
        ce_ram = 1
        load_inst_reg = 1

    else if (ring_counter[3] == 1)

        //add memory to accumulator - ADD B
        if (instruction = ADD_B)
            enable_b_reg = 1
            load_temp_reg = 1
        //subtract memory from accumulator - SUB B
        if (instruction = SUB_B)
            enable_b_reg = 1
            load_temp_reg = 1
         //add memory to accumulator - ADD C
        if (instruction = ADD_C)
            enable_c_reg = 1
            load_temp_reg = 1
        //subtract memory from accumulator - SUB C
        if (instruction = SUB_C)
            enable_c_reg = 1
            load_temp_reg = 1
        //output accumulator - OUT
        if (instruction == OUT)
            enable_accum = 1
            load_output_reg = 0
        if (instruction = HLT)
            hlt_clk = 1

    else if (ring_counter[4] == 1)
        //add memory to accumulator - ADD B
        if (instruction == ADD_B)
            enable_alu = 1
            load_accum = 1
        //subtract memory from accumulator - SUB B
        if (instruction == SUB_B)
            enable_alu = 1
            load_accum = 1
        //add memory to accumulator - ADD C
        if (instruction == ADD_C)
            enable_alu = 1
            load_accum = 1
        //subtract memory from accumulator - SUB C
        if (instruction == SUB_C)
            enable_alu = 1
            load_accum = 1

    else if (ring_counter[4] == 1)
        //add memory to accumulator - ADD B
        if (instruction == ADD_B)
            enable_alu = 1
            load_accum = 0
        //subtract memory from accumulator - SUB B
        if (instruction == SUB_B)
            enable_alu = 1
            load_accum = 0
            sub_mode = 1
        //add memory to accumulator - ADD C
        if (instruction == ADD_B)
            enable_alu = 1
            load_accum = 0
        //subtract memory from accumulator - SUB C
        if (instruction == SUB_B)
            enable_alu = 1
            load_accum = 0
            sub_mode = 1
end

//2-byte Instructions
    //LDA
    //STA
    //JMP
    //JC
    //JZ
    //MVI Accum
    //MVI B
    //MVI C
else if (instruction == MVI_ACCUM || instruction == MVI_B || instruction == MVI_C || instruction == LDA || instruction == STA || instruction == JMP || instruction == JC || instruction == JZ) begin
    extended_fetch = 1

    if (ring_counter[0] == 1)
        enable_pc = 1
        load_mar = 1
    
    else if (ring_counter[1] == 1)
        count_pc = 1

    else if (ring_counter[2] == 1)
        ce_ram = 1
        load_inst_reg = 1

    else if (ring_counter[3] == 1)
            enable_pc = 1
            load_mar = 1
            
    else if (ring_counter[4] == 1)
            count_pc = 1

    else if (ring_counter[5] == 1)

        //load accumulator from memory - LDA
        if (instruction = LDA)
            ce_ram = 1 //COME BACK
        //Store accumulator into memory - STA
        if (instruction = STA)
            ce_ram = 1
            enable_mdr_reg = 1 
            load_mar = 1
        //Jump uncoditionally - JMP
        if (instruction = JMP)
            ce_ram = 1
            enable_mdr_reg = 1
            load_pc = 1
        //jump if carry - JC
        if (instruction = JC)
            if (carry_flag = 1)
                ce_ram = 1
                enable_mdr_reg = 1
                load_pc = 1
        //jump if zero - JZ
        if (instruction = JC)
            if (zero_flag = 1)
                ce_ram = 1
                enable_mdr_reg = 1
                load_pc = 1
        //Move Immediately - MVI Accum
        if (instruction = MVI_ACCUM)
            ce_ram = 1
            enable_mdr_reg = 1
            load_accum = 1
        //Move Immediately - MVI B
        if (instruction = MVI_B)
            ce_ram = 1
            enable_mdr_reg = 1
            load_b_reg = 1
         //Move Immediately - MVI C
        if (instruction = MVI_B)
            ce_ram = 1
            enable_mdr_reg = 1
            load_c_reg = 1


    else if (ring_counter[6] == 1)
        //load accumulator from memory - LDA
        if (instruction = LDA)
            load_mar = 1
            enable_mdr_reg = 1
        //Store accumulator into memory - STA
        if (instruction = STA)
            enable_accum = 1
            load_mdr_reg = 1 

    else if (ring_counter[7] == 1)
        //load accumulator from memory - LDA
        if (instruction = LDA)
            enable_mdr_reg = 1 
            load_accum = 1
        //Store accumulator into memory - STA
        if (instruction = STA)
            we_ram = 1
            ce_ram = 1
            enable_mdr_reg = 1 
end
    
// if (ring_counter[0] == 1)

//     count_pc = 0
//     enable_pc = 1
//     load_mar = 0
//     ce_ram = 1
//     we_ram = 1
//     load_inst_reg = 1
//     enable_inst_reg = 1
//     load_accum = 1 
//     enable_accum = 0
//     sub_mode = 0
//     enable_alu = 0
//     load_b_reg = 1
//     load_output_reg = 1
//     load_pc = 0

// else if (ring_counter[1] == 1)

//     count_pc = 1
//     enable_pc = 0
//     load_mar = 1
//     ce_ram = 1
//     we_ram = 1
//     load_inst_reg = 1
//     enable_inst_reg = 1
//     load_accum = 1 
//     enable_accum = 0
//     sub_mode = 0
//     enable_alu = 0
//     load_b_reg = 1
//     load_output_reg = 1
//     load_pc = 0

// else if (ring_counter[2] == 1)

//     count_pc = 0
//     enable_pc = 0
//     load_mar = 1
//     ce_ram = 0
//     we_ram = 1
//     load_inst_reg = 0
//     enable_inst_reg = 1
//     load_accum = 1 
//     enable_accum = 0
//     sub_mode = 0
//     enable_alu = 0
//     load_b_reg = 1
//     load_output_reg = 1
//     load_pc = 0
end
endmodule