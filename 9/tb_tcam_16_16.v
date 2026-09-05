`timescale 1ns / 1ps

module tb_tcam_16_16;

    reg         clk;
    reg         rst;
    reg         wr_en;
    reg  [3:0]  wr_addr;
    reg  [15:0] wr_data;
    reg  [15:0] wr_mask;
    reg         search_en;
    reg  [15:0] search_data;

    wire [15:0] match_lines;
    wire        match_found;
    wire [3:0]  match_addr;

    tcam_16_16 uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_mask(wr_mask),
        .search_en(search_en),
        .search_data(search_data),
        .match_lines(match_lines),
        .match_found(match_found),
        .match_addr(match_addr)
    );

    always #5 clk = ~clk;

    task write_entry(
        input [3:0]  addr,
        input [15:0] data,
        input [15:0] mask
    );
    begin
        @(posedge clk);
        wr_en   <= 1'b1;
        wr_addr <= addr;
        wr_data <= data;
        wr_mask <= mask;
        @(posedge clk);
        wr_en   <= 1'b0;
    end
    endtask

    initial begin
        clk         = 0;
        rst         = 1;
        wr_en       = 0;
        wr_addr     = 0;
        wr_data     = 0;
        wr_mask     = 0;
        search_en   = 0;
        search_data = 0;

        #20;
        rst = 0;
        #10;

        write_entry(4'd0, 16'b0110_0000_0000_0000, 16'b0000_1111_1111_1111);
        write_entry(4'd1, 16'b0010_1100_0000_0000, 16'b0101_0010_1111_1111);
        write_entry(4'd2, 16'b0110_1000_0000_0000, 16'b1000_0111_1111_1111);
        write_entry(4'd3, 16'b1111_0000_1111_0000, 16'b0000_0000_0000_0000);

        #20;

        @(posedge clk);
        search_en   <= 1'b1;
        search_data <= 16'b0110_1110_0000_0000;
        
        #5;
        $display("Match Found? : %b", match_found);
        $display("Match Lines  : %b", match_lines);
        $display("First Match  : Row %0d", match_addr);

        #20;

        @(posedge clk);
        search_data <= 16'b1000_0000_0000_0000;

        #5;
        $display("Match Found? : %b", match_found);
        $display("Match Lines  : %b", match_lines);

        #20;
        $finish;
    end

    initial begin
        $dumpfile("tcam_waveform.vcd");
        $dumpvars(0, tb_tcam_16_16);
    end

endmodule
