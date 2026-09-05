`timescale 1ns/1ps

module tb_booth_mult();
    reg clk, rst, start;
    reg signed [7:0] M, Q;
    wire signed [15:0] result;
    wire ready;

    reg signed [15:0] expected;

    booth_mult uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .M_in(M),
        .Q_in(Q),
        .result(result),
        .ready(ready)
    );

    always #5 clk = ~clk;

  task test_multiply;
        input signed [7:0] m_val;
        input signed [7:0] q_val;
        begin
            @(negedge clk);
            M = m_val;
            Q = q_val;
            expected = M * Q;
            start = 1;
            
            @(negedge clk);
            start = 0;
            
            wait(ready == 1);
            
            if (result !== expected)
                $display("ERROR: Time=%0t | %d x %d = %d (Expected: %d)", $time, M, Q, result, expected);
            else
                $display("PASS: Time=%0t | %d x %d = %d", $time, M, Q, result);
                
            wait(ready == 0);
        end
    endtask

    initial begin
        clk = 0; rst = 1; start = 0; M = 0; Q = 0;
        #15 rst = 0;

        test_multiply(8'd7, 8'd3);
        test_multiply(8'sd5, -8'sd4);
        test_multiply(-8'sd6, 8'sd7);
        test_multiply(-8'sd8, -8'sd3);
        
        test_multiply(8'd0, 8'd12);
        test_multiply(-8'sd15, 8'd0);
        test_multiply(8'd0, 8'd0);
        
        test_multiply(8'sd127, 8'sd127);
        test_multiply(-8'sd128, -8'sd128);
        test_multiply(-8'sd128, 8'sd127);
        test_multiply(8'sd127, -8'sd128);


        #20 $stop;
    end
endmodule