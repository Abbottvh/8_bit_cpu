// 8-bit adder/subtractor
module eight_bit_adder_subtractor (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire sub,                     // 1 = subtract, 0 = add
    output wire [7:0] sum,
    output wire zero_flag,
    output wire carry_flag
);

    wire [8:0] result;

    // Perform addition or subtraction with carry bit
    assign result = sub ? (a - b) : (a + b);

    assign sum = result[7:0];
    assign zero_flag = (result[7:0] == 8'b0);
    assign carry_flag = result[8];  // MSB is the carry

endmodule
