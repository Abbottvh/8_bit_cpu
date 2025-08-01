module program_counter (
    input wire clk,
    input wire clear,
    input wire count,
    input wire load,
    input wire [7:0] jump_address,
    output reg [7:0] address
);
    always @(posedge clk or posedge clear) begin
        if (clear)
            address <= 8'b00000000;
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
    input wire extended_fetch,
    output reg [9:0] t_state
);

    // Initialize to T0 on reset
    always @(posedge clk) begin
        if (clear) begin
            t_state <= 10'b0000000001;  // Start at T0
        end else if (enable) begin
            // If we're at T5 and not extended, reset to T0
            if (t_state[5] && !extended_fetch) begin
                t_state <= 10'b0000000001; // Reset to T0 after T5
            end
            // If we're at T9, always reset to T0
            else if (t_state[9]) begin
                t_state <= 10'b0000000001;
            end
            // Otherwise, shift left (move to next T-state)
            else begin
                t_state <= {t_state[8:0], t_state[9]};
            end
        end
    end

endmodule
