`timescale 1ns / 1ps

module tb_Pipeline_CPU();

    reg clk;
    reg rst;
    reg signed [7:0] test_Ar, test_Ai, test_Br, test_Bi;
    wire signed [15:0] result_r;
    wire signed [15:0] result_i;
    wire done;
    wire [4:0] current_pc;

    Pipeline_CPU uut (
        .clk(clk),
        .rst(rst),
        .data_Ar(test_Ar),
        .data_Ai(test_Ai),
        .data_Br(test_Br),
        .data_Bi(test_Bi),
        .result_r(result_r),
        .result_i(result_i),
        .done(done),
        .current_pc(current_pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    always @(*) begin
        case (current_pc)
            5'd0: begin test_Ar = 3;  test_Ai = 4;  test_Br = 2;  test_Bi = 1;  end 
            5'd1: begin test_Ar = -5; test_Ai = 2;  test_Br = 1;  test_Bi = -3; end 
            5'd2: begin test_Ar = 2;  test_Ai = 3;  test_Br = 4;  test_Bi = 5;  end 
            5'd3: begin test_Ar = 0;  test_Ai = 0;  test_Br = -7; test_Bi = 8;  end 
            5'd4: begin test_Ar = -2; test_Ai = -1; test_Br = -3; test_Bi = -2; end 
            default: begin test_Ar = 0; test_Ai = 0; test_Br = 0; test_Bi = 0; end
        endcase
    end

    integer op_count = 0;

    initial begin
        $display("Starting Simulation...");
        rst = 1;
        #15;
        rst = 0;
        
        wait(op_count == 5);
        #20;
        $display("Simulation done.");
        $stop;
    end

    always @(posedge clk) begin
        if (done) begin
            op_count = op_count + 1;
            
            case (op_count)
                1: begin
                    $display("Test 1 (ADD) | In: A=(3+4i), B=(2+1i) | Res = %0d+%0di | Exp: 5+5i", result_r, result_i);
                    if (result_r == 5 && result_i == 5) $display(" -> PASS"); else $display(" -> FAIL");
                end
                2: begin
                    $display("Test 2 (SUB) | In: A=(-5+2i), B=(1-3i) | Res = %0d+%0di | Exp: -6+5i", result_r, result_i);
                    if (result_r == -6 && result_i == 5) $display(" -> PASS"); else $display(" -> FAIL");
                end
                3: begin
                    $display("Test 3 (MUL) | In: A=(2+3i), B=(4+5i) | Res = %0d+%0di | Exp: -7+22i", result_r, result_i);
                    if (result_r == -7 && result_i == 22) $display(" -> PASS"); else $display(" -> FAIL");
                end
                4: begin
                    $display("Test 4 (ADD) | In: A=(0+0i), B=(-7+8i) | Res = %0d+%0di | Exp: -7+8i", result_r, result_i);
                    if (result_r == -7 && result_i == 8) $display(" -> PASS"); else $display(" -> FAIL");
                end
                5: begin
                    $display("Test 5 (MUL) | In: A=(-2-1i), B=(-3-2i) | Res = %0d+%0di | Exp: 4+7i", result_r, result_i);
                    if (result_r == 4 && result_i == 7) $display(" -> PASS"); else $display(" -> FAIL");
                end
            endcase
        end
    end

endmodule