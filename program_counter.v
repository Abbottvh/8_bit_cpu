module program_counter (
    input wire clk,
    input wire clear,
    input wire count,
    input wire load,
    input wire [15:0] jump_address,
    output reg [15:0] address
);
    always @(posedge clk or posedge clear) begin
        if (clear)
            address <= 16'b0000000000000000;
        else if (load)
            address <= jump_address;
        else if (count)
            address <= address + 1;
    end
endmodule

module ring_counter (
    input wire clk,
    input wire clear,
    input wire enable,
    input wire [1:0] mode,          // 00=6-state, 01=10-state, 10=15-state
    output reg [14:0] t_state       // one-hot up to 15 states (T0..T14)
);

    // Helper: determine wrap bit index based on mode
    function automatic integer wrap_index;
        input [1:0] mode_in;
        begin
            case (mode_in)
                2'b00: wrap_index = 5;   // 6-state: last is T5
                2'b01: wrap_index = 9;   //10-state: last is T9
                2'b10: wrap_index = 14;  //15-state: last is T14
                default: wrap_index = 5; // fallback to 6-state
            endcase
        end
    endfunction

    // Initialize to T0 on reset; otherwise, advance or wrap
    always @(posedge clk) begin
        if (clear) begin
            t_state <= 15'b000000000000001;  // Start at T0 (LSB)
        end else if (enable) begin
            if (t_state == (15'b1 << wrap_index(mode))) begin
                // wrap back to T0
                t_state <= 15'b000000000000001;
            end else begin
                // shift one-hot left
                t_state <= t_state << 1;
            end
        end
    end

endmodule


