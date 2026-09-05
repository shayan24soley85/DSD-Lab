`timescale 1ns/1ns

module tb_uart_top;

    reg clk;
    reg rst;
    reg start;
    reg [6:0] data_in;
    
    wire [7:0] data_out;
    wire done;
    
    reg [7:0] expected_val;
    integer pass_count = 0;
    integer fail_count = 0;

    uart_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .data_out(data_out),
        .done(done)
    );

    always #5 clk = ~clk;

    task test_scenario(input [6:0] test_data, input integer test_num);
        begin
            data_in = test_data;
            expected_val = {test_data, ^test_data}; 
            
            start = 1;
            #10 start = 0;
            
            wait(done == 1);
            #10; 
            
            if (data_out == expected_val) begin
                $display("Scenario %0d: Input = %b | Expected = %b | Received = %b -> [PASS]", test_num, data_in, expected_val, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("Scenario %0d: Input = %b | Expected = %b | Received = %b -> [FAIL]", test_num, data_in, expected_val, data_out);
                fail_count = fail_count + 1;
            end
            
            #50; 
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        data_in = 7'b0000000;

        #20 rst = 0;
        #10;
        
        $display("          UART Simulation Started...                     ");
        
        test_scenario(7'b0000000, 1);
        test_scenario(7'b1111111, 2);
        test_scenario(7'b1010101, 3);
        test_scenario(7'b0101010, 4);
        test_scenario(7'b1100110, 5);
        test_scenario(7'b0011001, 6);
        test_scenario(7'b0001000, 7);

        $display("Simulation Finished!");
        $stop;
    end
endmodule