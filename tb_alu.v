`timescale 1ns / 1ps

module tb_eight_bit_adder_subtractor;

    reg [7:0] a, b;
    reg sub;        // 0 = add, 1 = subtract
    reg enable;
    wire [7:0] s;

    // Instantiate your DUT (Device Under Test)
    eight_bit_adder_subtractor dut (
        .a(a),
        .b(b),
        .sub(sub),
        .enable(enable),
        .s(s)
    );

    initial begin
        // Initialize signals
        enable = 1;  // Enable output buffer so result is visible
        sub = 0;     // Addition mode

        // Test Case 1: 15 + 10 = 25
        a = 8'd15;
        b = 8'd10;
        #10;  // wait 10ns
        $display("Test 1: %d + %d = %d", a, b, s);

        // Test Case 2: 100 + 155 = 255 (max 8-bit)
        a = 8'd100;
        b = 8'd60;
        #10;
        $display("Test 2: %d + %d = %d", a, b, s);

        // Test Case 3: 200 + 100 = 44 (with overflow, if you want to check overflow)
        a = 8'd200;
        b = 8'd100;
        #10;
        $display("Test 3: %d + %d = %d", a, b, s);

        $finish;  // End simulation
    end

endmodule
