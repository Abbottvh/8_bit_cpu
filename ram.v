module ram (
    input wire clk,              // clock
    input wire ce,               // chip enable (active high)
    input wire we,               // write enable (active high)
    input wire [7:0] addr,       // 8-bit address (256 locations)
    input wire [7:0] data_in,    // 8-bit input data
    output reg [7:0] data_out    // 8-bit output data
);

    // Declare 256 x 8-bit memory
    reg [7:0] mem [0:255];

    // Load memory content from external file at simulation start
    initial begin
        $readmemh("instructions.mem", mem);
        $display("Initial RAM[0] = %h", mem[0]);
    end

    // Synchronous write
    always @(posedge clk) begin
        if (ce && we) begin
            mem[addr] <= data_in;
            $display("Wrote %h to RAM[%0d] at time %0t", data_in, addr, $time);
        end
    end

    // Asynchronous read
    always @(*) begin
        if (ce) begin
            data_out = mem[addr];
        end else begin
            data_out = 8'b0;  // Drive zero when not enabled
        end
    end

endmodule
