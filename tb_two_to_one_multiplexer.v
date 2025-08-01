`timescale 1ns / 1ps

module two_to_one_multiplexer_tb;

    // Inputs
    reg [15:0] data_in;
    reg flip_flop;

    // Output
    wire [7:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    two_to_one_multiplexer uut (
        .data_in(data_in),
        .flip_flop(flip_flop),
        .data_out(data_out)
    );

    initial begin
        $display("Time | flip_flop | data_in             | data_out");
        $display("-----+-----------+---------------------+---------");

        // Test case 1: flip_flop = 0, should select data_in[15:8]
        data_in = 16'hABCD;
        flip_flop = 0;
        #10;
        $display("%4t |     %b     |   0x%h         |   0x%h", $time, flip_flop, data_in, data_out);

        // Test case 2: flip_flop = 1, should select data_in[7:0]
        flip_flop = 1;
        #10;
        $display("%4t |     %b     |   0x%h         |   0x%h", $time, flip_flop, data_in, data_out);

        // Test case 3: flip_flop = 0, different data
        data_in = 16'h1234;
        flip_flop = 0;
        #10;
        $display("%4t |     %b     |   0x%h         |   0x%h", $time, flip_flop, data_in, data_out);

        // Test case 4: flip_flop = 1, different data
        flip_flop = 1;
        #10;
        $display("%4t |     %b     |   0x%h         |   0x%h", $time, flip_flop, data_in, data_out);

        $finish;
    end

endmodule
