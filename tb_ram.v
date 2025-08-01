`timescale 1ns / 1ps

module ram_tb;

    // Testbench signals
    reg clk;
    reg ce;
    reg we;
    reg [7:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate the RAM module
    ram uut (
        .clk(clk),
        .ce(ce),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk = 0;
        ce = 0;
        we = 0;
        addr = 8'b0;
        data_in = 8'b0;

        $display("Starting RAM test...");

        // Wait for memory to load
        #10;

        // --- Check preloaded data ---
        ce = 1;
        we = 0;
        addr = 8'd0;
        #10;
        $display("Time: %0t | Read RAM[0] = %h (should match instructions.mem)", $time, data_out);

        // --- Write to RAM[1] ---
        addr = 8'd1;
        data_in = 8'hAB;
        we = 1;
        #10;

        // --- Disable write, read RAM[1] ---
        we = 0;
        #10;
        $display("Time: %0t | Read RAM[1] = %h (should be AB)", $time, data_out);

        // --- Write to RAM[42], then read ---
        addr = 8'd42;
        data_in = 8'h3C;
        we = 1;
        #10;

        we = 0;
        #10;
        $display("Time: %0t | Read RAM[42] = %h (should be 3C)", $time, data_out);

        // --- Disable CE ---
        ce = 0;
        addr = 8'd1;
        #10;
        $display("Time: %0t | Read RAM[1] with CE=0 = %h (should be 00)", $time, data_out);

        $display("RAM test complete.");
        $finish;
    end

endmodule
