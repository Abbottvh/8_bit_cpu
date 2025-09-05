`timescale 1ns / 1ps

module tb_cb_register;

    reg clk;
    reg clear;
    reg load;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate the register
    cb_register dut (
        .clk(clk),
        .clear(clear),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clear = 0;
        load = 0;
        data_in = 8'b00000000;

        // Wait for a few clock cycles
        #10;

        // Test 1: Load data_in when load = 1
        data_in = 8'hA5;
        load = 1;
        #10;  // wait one clock cycle
        load = 0;
        #10;
        $display("Test 1 - Load: data_out = %h (expected A5)", data_out);

        // Test 2: Hold value when load = 0
        data_in = 8'hFF;
        #20;  // wait two clock cycles
        $display("Test 2 - Hold: data_out = %h (expected A5)", data_out);

        // Test 3: Clear register
        clear = 1;
        #10;  // clear asserted for one clock
        clear = 0;
        #10;
        $display("Test 3 - Clear: data_out = %h (expected 00)", data_out);

        // Test 4: Load new value after clear
        data_in = 8'h3C;
        load = 1;
        #10;
        load = 0;
        #10;
        $display("Test 4 - Load after clear: data_out = %h (expected 3C)", data_out);

        $finish;
    end

endmodule
