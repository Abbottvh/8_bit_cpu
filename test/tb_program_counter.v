`timescale 1ns/1ps

module tb_program_counter;

    // Clock and signals
    reg clk = 0;
    reg clear = 0;

    // Program counter signals
    reg pc_count = 0;
    reg pc_load = 0;
    reg [15:0] jump_address = 16'h00;
    wire [15:0] pc_address;

    // Ring counter signals
    reg rc_enable = 0;
    reg [1:0] mode = 2'b00;
    wire [14:0] t_state;

    // Instantiate Program Counter
    program_counter uut_pc (
        .clk(clk),
        .clear(clear),
        .count(pc_count),
        .load(pc_load),
        .jump_address(jump_address),
        .address(pc_address)
    );

    // Instantiate Ring Counter
    ring_counter uut_rc (
        .clk(clk),
        .clear(clear),
        .enable(rc_enable),
        .mode(mode),
        .t_state(t_state)
    );

    // Clock generator
    always #5 clk = ~clk;  // 100MHz clock

    // Test sequence
    initial begin
        $display("Starting Testbench...");
        $monitor("Time: %0t | PC: %h | T-State: %b", $time, pc_address, t_state);

        // Reset system
        clear = 1;
        #10;
        clear = 0;

        // Load PC with jump address
        pc_load = 1;
        jump_address = 16'hA5;
        #10;
        pc_load = 0;

        // Count PC up 3 times
        pc_count = 1;
        #30;
        pc_count = 0;
        pc_load = 1;
        jump_address = 16'hb5;
        #10
        pc_load = 0;
        pc_count = 1;
        #30;
        pc_count = 0;


        // Reset PC again
        clear = 1;
        #10;
        clear = 0;

        // Test ring counter - short fetch (6 T-states)
        rc_enable = 1;
        mode = 2'b00;
        #70;  // Allow enough time to cycle through T0-T5

        // Reset ring counter
        clear = 1;
        #10;
        clear = 0;

        // Test ring counter - extended fetch (10 T-states)
        mode = 2'b01;
        #100;

        // Reset ring counter
        clear = 1;
        #10;
        clear = 0;

        // Test ring counter - extended fetch (10 T-states)
        mode = 2'b10;
        #160;

        // Done
        $display("Testbench Complete.");
        $finish;
    end

endmodule
