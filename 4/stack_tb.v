`timescale 1ns / 1ps

module stack_tb;

    reg        Clk;
    reg        RstN;
    reg  [3:0] Data_In;
    reg        Push;
    reg        Pop;
    wire [3:0] Data_Out;
    wire       Full;
    wire       Empty;

    stack uut (
        .Clk      (Clk),
        .RstN     (RstN),
        .Data_In  (Data_In),
        .Push     (Push),
        .Pop      (Pop),
        .Data_Out (Data_Out),
        .Full     (Full),
        .Empty    (Empty)
    );

    initial Clk = 0;
    always #5 Clk = ~Clk;

    task push_val(input [3:0] val);
        begin
            @(negedge Clk);
            Data_In = val;
            Push = 1;
            Pop  = 0;
            @(negedge Clk);
            Push = 0;
        end
    endtask

    task pop_val;
        begin
            @(negedge Clk);
            Push = 0;
            Pop  = 1;
            @(negedge Clk);
            Pop = 0;
        end
    endtask

    initial begin
        RstN    = 1;
        Push    = 0;
        Pop     = 0;
        Data_In = 4'd0;

        #2;
        RstN = 0;
        #20;
        RstN = 1;
        #10;

        $display("===== TEST 1: Push 8 values (fill the stack) =====");
        push_val(4'd1);
        push_val(4'd3);
        push_val(4'd5);
        push_val(4'd7);
        push_val(4'd9);
        push_val(4'd11);
        push_val(4'd13);
        push_val(4'd15);

        #10;
        $display("Full = %b (expected 1)", Full);

        $display("\n===== TEST 2: Try to push when full (should be ignored) =====");
        push_val(4'd2);
        #10;
        $display("Full = %b (expected 1, push was ignored)", Full);

        $display("\n===== TEST 3: Pop all 8 values (LIFO order) =====");
        $display("Expected order: 15, 13, 11, 9, 7, 5, 3, 1");
        pop_val; #1; $display("Popped: %0d", Data_Out);
        pop_val; #1; $display("Popped: %0d", Data_Out);
        pop_val; #1; $display("Popped: %0d", Data_Out);
        pop_val; #1; $display("Popped: %0d", Data_Out);
        pop_val; #1; $display("Popped: %0d", Data_Out);
        pop_val; #1; $display("Popped: %0d", Data_Out);
        pop_val; #1; $display("Popped: %0d", Data_Out);
        pop_val; #1; $display("Popped: %0d", Data_Out);

        #10;
        $display("Empty = %b (expected 0)", Empty);

        $display("\n===== TEST 4: Try to pop when empty (should be ignored) =====");
        pop_val;
        #10;
        $display("Empty = %b (expected 0, pop was ignored)", Empty);

        $display("\n===== TEST 5: Push 3, Pop 1, Push 2, Pop all =====");
        push_val(4'd2);
        push_val(4'd4);
        push_val(4'd6);
        pop_val; #1; $display("Popped: %0d (expected 6)", Data_Out);
        push_val(4'd8);
        push_val(4'd10);

        pop_val; #1; $display("Popped: %0d (expected 10)", Data_Out);
        pop_val; #1; $display("Popped: %0d (expected 8)",  Data_Out);
        pop_val; #1; $display("Popped: %0d (expected 4)",  Data_Out);
        pop_val; #1; $display("Popped: %0d (expected 2)",  Data_Out);

        #10;
        $display("Empty = %b (expected 0)", Empty);

        $display("\n===== TEST 6: Simultaneous Push and Pop =====");
        push_val(4'd7);
        push_val(4'd14);

        @(negedge Clk);
        Data_In = 4'd3;
        Push = 1;
        Pop  = 1;
        @(negedge Clk);
        Push = 0;
        Pop  = 0;
        #1;
        $display("After simultaneous Push(3) & Pop: Data_Out = %0d (expected 14)", Data_Out);

        pop_val; #1; $display("Popped: %0d (expected 3)", Data_Out);
        pop_val; #1; $display("Popped: %0d (expected 7)", Data_Out);

        $display("\n===== ALL TESTS COMPLETE =====");
        #20;
        $finish;
    end

    initial begin
        $dumpfile("stack_tb.vcd");
        $dumpvars(0, stack_tb);
    end

endmodule
