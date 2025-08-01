
//full adder
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

//bus buffer to allow me to control when to send things to the bus
// module bus_driver (
//     input  wire [7:0] data_in,
//     input  wire enable,
//     output wire [7:0] data_out
// );

//     // Tri-state all 8 bits at once
//     assign data_out = (enable) ? data_in : 8'bz;

// endmodule

//8-bit adder/subtractor
module eight_bit_adder_subtractor (
    //the two numbers
    input wire [7:0] a,
    input wire [7:0] b,
    //sub mode (1 = subtraction, 0 = addition)
    input wire sub,
    //enable the output to be sent to the bus
    input wire enable,
    //the sum output
    output wire [7:0] sum

);
    wire [7:0] in;
    //generating the input signal to the full adders through XOR with sub
    assign in = b ^ {8{sub}};
    
    wire [7:0] sum;
    wire [7:0] carry;

    //generating 8 full adders linked together
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            if (i == 0) begin
                //for the first adder making one of the inputs sub
                full_adder fa (
                    .a(a[i]),
                    .b(in[i]),
                    .cin(sub),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
                //for all others making the input the carry from the previous adder
            end else begin
                full_adder fa (
                    .a(a[i]),
                    .b(in[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    //outputting the sum if enable is on
    // bus_driver driver (
    //     .data_in(sum),
    //     .enable(enable),
    //     .data_out(s)
    // );
endmodule