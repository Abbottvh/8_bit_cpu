// module d_register (
//     input wire clk,
//     input wire q,
//     input wire clear,
//     output reg d

// );


//     always @(posedge clk or posedge clear) begin
//         if (clear)
//             q <= 1'b0;   // Asynchronous reset
//         else
//             q <= d;      // Normal D flip-flop behavior
//     end
//endmodule


module cb_register (
    input wire clk,
    input wire clear,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

  always @(posedge clk or posedge clear) begin
    if (clear)
      data_out <= 8'b0;
    else if (load)
        data_out <= data_in;
  end

endmodule