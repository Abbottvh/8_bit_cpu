`timescale 1ns/1ps

module tb_three_state_buffer();

    reg [7:0] data_in;
    reg enable;
    wire [7:0] data_out;

    // Instantiate the three_state_buffer
    three_state_buffer uut (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );

    initial begin
        // Monitor signals
        $monitor("Time: %0t | enable = %b | data_in = %h | data_out = %h", $time, enable, data_in, data_out);

        // Initialize inputs
        data_in = 8'h00;
        enable = 0;
        #10;

        // Drive data_in, enable low (output should be high-Z)
        data_in = 8'hAA;
        enable = 0;
        #10;

        // Enable buffer, data_out should follow data_in
        enable = 1;
        #10;

        // Change data_in, data_out should update accordingly
        data_in = 8'h55;
        #10;

        // Disable buffer again, data_out should go high-Z (displayed as 'z')
        enable = 0;
        #10;

        $finish;
    end

endmodule
