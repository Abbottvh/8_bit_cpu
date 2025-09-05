module uart #(
    parameter CLK_FREQ = 50000000, // system clock frequency
    parameter BAUD     = 115200
)(
    input  wire        clk,
    input  wire        reset,

    // CPU side
    input  wire [15:0] addr,
    input  wire [7:0]  data_in,
    output reg  [7:0]  data_out,
    input  wire        mem_read,
    input  wire        mem_write,

    // UART pins
    output reg         tx,
    input  wire        rx
);
    // Memory map constants
    localparam UART_TX_ADDR     = 16'hFF00;
    localparam UART_RX_ADDR     = 16'hFF01;
    localparam UART_STATUS_ADDR = 16'hFF02;

    // Baud rate divider
    localparam integer DIV = CLK_FREQ / BAUD;

    // Transmit state
    reg [9:0] tx_shift = 10'b1111111111; // start + data + stop
    reg [15:0] tx_div_cnt = 0;
    reg [3:0]  tx_bit_cnt = 0;
    reg        tx_busy = 0;

    // Receive state
    reg [9:0] rx_shift = 0;
    reg [15:0] rx_div_cnt = 0;
    reg [3:0]  rx_bit_cnt = 0;
    reg        rx_busy = 0;
    reg [7:0]  rx_data = 0;
    reg        rx_ready = 0;

    // UART TX logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1; // idle high
            tx_busy <= 0;
            tx_shift <= 10'b1111111111;
        end else begin
            // Write to TX register
            if (mem_write && addr == UART_TX_ADDR && !tx_busy) begin
                tx_shift <= {1'b1, data_in, 1'b0}; // stop, data, start
                tx_bit_cnt <= 0;
                tx_div_cnt <= 0;
                tx_busy <= 1;
            end

            // Send bits
            if (tx_busy) begin
                if (tx_div_cnt == DIV-1) begin
                    tx_div_cnt <= 0;
                    tx <= tx_shift[0];
                    tx_shift <= {1'b1, tx_shift[9:1]};
                    tx_bit_cnt <= tx_bit_cnt + 1;
                    if (tx_bit_cnt == 9) tx_busy <= 0;
                end else begin
                    tx_div_cnt <= tx_div_cnt + 1;
                end
            end
        end
    end

    // UART RX logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_busy <= 0;
            rx_ready <= 0;
        end else begin
            if (!rx_busy && !rx) begin
                rx_busy <= 1;
                rx_div_cnt <= DIV/2; // sample mid-bit
                rx_bit_cnt <= 0;
            end else if (rx_busy) begin
                if (rx_div_cnt == DIV-1) begin
                    rx_div_cnt <= 0;
                    rx_shift <= {rx, rx_shift[9:1]};
                    rx_bit_cnt <= rx_bit_cnt + 1;
                    if (rx_bit_cnt == 9) begin
                        rx_busy <= 0;
                        rx_data <= rx_shift[8:1];
                        rx_ready <= 1;
                    end
                end else begin
                    rx_div_cnt <= rx_div_cnt + 1;
                end
            end

            // Read from RX register clears ready flag
            if (mem_read && addr == UART_RX_ADDR) rx_ready <= 0;
        end
    end

    // CPU read interface
    always @(*) begin
        case (addr)
            UART_RX_ADDR:     data_out = rx_data;
            UART_STATUS_ADDR: data_out = {6'b0, rx_ready, ~tx_busy};
            default:          data_out = 8'h00;
        endcase
    end

endmodule
