module tcam_16_16 (
    input  wire        clk,
    input  wire        rst,
    input  wire        wr_en,
    input  wire [3:0]  wr_addr,
    input  wire [15:0] wr_data,
    input  wire [15:0] wr_mask,
    input  wire        search_en,
    input  wire [15:0] search_data,
    output reg  [15:0] match_lines,
    output wire        match_found,
    output reg  [3:0]  match_addr
);

    reg [15:0] mem_data [0:15];
    reg [15:0] mem_mask [0:15];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) begin
                mem_data[i] <= 16'h0000;
                mem_mask[i] <= 16'h0000;
            end
        end else if (wr_en) begin
            mem_data[wr_addr] <= wr_data;
            mem_mask[wr_addr] <= wr_mask;
        end
    end

    always @(*) begin
        if (search_en) begin
            for (i = 0; i < 16; i = i + 1) begin
                match_lines[i] = ((search_data & ~mem_mask[i]) == (mem_data[i] & ~mem_mask[i]));
            end
        end else begin
            match_lines = 16'h0000;
        end
    end

    assign match_found = |match_lines;

    always @(*) begin
        match_addr = 4'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            if (match_lines[i]) begin
                match_addr = i[3:0];
            end
        end
    end

endmodule
