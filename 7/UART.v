module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [6:0] data_in,
    output reg tx_out,
    output reg tx_busy
);
    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;
    wire parity;

    assign parity = ^data_in;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_out <= 1'b1;
            tx_busy <= 1'b0;
            bit_cnt <= 4'd0;
            shift_reg <= 10'h3FF;
        end else begin
            if (tx_start && !tx_busy) begin
                shift_reg <= {1'b1, data_in, parity, 1'b0};
                tx_busy <= 1'b1;
                bit_cnt <= 4'd0;
                tx_out <= 1'b1;
            end else if (tx_busy) begin
                tx_out <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};
                if (bit_cnt == 4'd9) begin
                    tx_busy <= 1'b0;
                    bit_cnt <= 4'd0;
                end else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
        end
    end
endmodule

module uart_rx (
    input clk,
    input rst,
    input rx_in,
    output reg [7:0] data_out,
    output reg rx_done
);
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam DONE    = 2'b10;

    reg [3:0] bit_cnt;
    reg [1:0] state;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_cnt <= 4'd0;
            rx_done <= 1'b0;
            data_out <= 8'd0;
        end else begin
            rx_done <= 1'b0;
            case (state)
                IDLE: begin
                    if (rx_in == 1'b0) begin
                        state <= RECEIVE;
                        bit_cnt <= 4'd0;
                    end
                end
                RECEIVE: begin
                    shift_reg <= {rx_in, shift_reg[7:1]};
                    if (bit_cnt == 4'd7) begin
                        state <= DONE;
                    end else begin
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                end
                DONE: begin
                    data_out <= shift_reg;
                    rx_done <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule

module uart_top (
    input clk,
    input rst,
    input start,
    input [6:0] data_in,
    output [7:0] data_out,
    output done
);
    wire serial_line;
    wire tx_busy;

    uart_tx tx_unit (
        .clk(clk),
        .rst(rst),
        .tx_start(start),
        .data_in(data_in),
        .tx_out(serial_line),
        .tx_busy(tx_busy)
    );

    uart_rx rx_unit (
        .clk(clk),
        .rst(rst),
        .rx_in(serial_line),
        .data_out(data_out),
        .rx_done(done)
    );
endmodule