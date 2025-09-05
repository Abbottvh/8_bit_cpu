// Three-State Buffer
module three_state_buffer (
    input wire [7:0] data_in,
    input wire enable,
    output wire [7:0] data_out
);
    assign data_out = enable ? data_in : 8'bz;
endmodule