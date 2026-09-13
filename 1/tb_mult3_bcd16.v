
`timescale 1ns / 1ps

module tb_mult3_bcd16;

    reg  [15:0] BCD;
    wire        Y;

    mult3_bcd16 uut (
        .BCD(BCD),
        .Y(Y)
    );

    integer pass_count = 0;
    integer fail_count = 0;

    task check_bcd (
        input [15:0] test_val,
        input expected_y,
        input [16*8:1] test_label
    );
        begin
            BCD = test_val;
            #10;
            if (Y === expected_y) begin
                $display("[PASS] %s | BCD = %h (%04x) | Expected Y = %b, Got Y = %b", 
                         test_label, BCD, BCD, expected_y, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %s | BCD = %h (%04x) | Expected Y = %b, Got Y = %b", 
                         test_label, BCD, BCD, expected_y, Y);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $display("==================================================================");
        $display("   TESTBENCH: 4-Digit BCD Divisibility by 3 Detector (mult3_bcd16)");
        $display("==================================================================");

        check_bcd(16'h0000, 1'b1, "0000 (0 / 3)");
        check_bcd(16'h0003, 1'b1, "0003 (3 / 3)");
        check_bcd(16'h0009, 1'b1, "0009 (9 / 3)");
        check_bcd(16'h0012, 1'b1, "0012 (12 / 3)");
        check_bcd(16'h0300, 1'b1, "0300 (300 / 3)");
        check_bcd(16'h1230, 1'b1, "1230 (1230 / 3)");
        check_bcd(16'h9999, 1'b1, "9999 (9999 / 3)");

        check_bcd(16'h0001, 1'b0, "0001 (Not mult 3)");
        check_bcd(16'h0002, 1'b0, "0002 (Not mult 3)");
        check_bcd(16'h0004, 1'b0, "0004 (Not mult 3)");
        check_bcd(16'h1000, 1'b0, "1000 (Not mult 3)");
        check_bcd(16'h9998, 1'b0, "9998 (Not mult 3)");

        check_bcd(16'h1110, 1'b1, "1110 (1+1+1+0 = 3)");
        check_bcd(16'h2580, 1'b1, "2580 (2+5+8+0 = 15)");
        check_bcd(16'h1234, 1'b0, "1234 (1+2+3+4 = 10)");

        $display("==================================================================");
        $display("   TEST SUMMARY: Total PASSED = %0d | Total FAILED = %0d", pass_count, fail_count);
        $display("==================================================================");

        $stop;
    end

endmodule
