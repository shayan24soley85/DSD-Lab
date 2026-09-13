`timescale 1ns / 1ps

module tb_mult11_bcd16;

    reg  [15:0] BCD;
    wire        Y;

    mult11_bcd16 uut (
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
        $display("   TESTBENCH: 4-Digit BCD Divisibility by 11 Detector (mult11_bcd16)");
        $display("==================================================================");

        check_bcd(16'h0000, 1'b1, "0000 (0 / 11)");
        check_bcd(16'h0011, 1'b1, "0011 (11 / 11)");
        check_bcd(16'h0022, 1'b1, "0022 (22 / 11)");
        check_bcd(16'h0121, 1'b1, "0121 (121 / 11)");
        check_bcd(16'h1221, 1'b1, "1221 (1221 / 11)");
        check_bcd(16'h0990, 1'b1, "0990 (990 / 11)");
        check_bcd(16'h9900, 1'b1, "9900 (9900 / 11)");
        check_bcd(16'h9009, 1'b1, "9009 (9009 / 11)");
        check_bcd(16'h9999, 1'b1, "9999 (9999 / 11)");

        check_bcd(16'h0924, 1'b1, "0924 (924 / 11)"); // S_even = 4+9=13, S_odd = 2+0=2, diff = +11
        check_bcd(16'h9020, 1'b1, "9020 (9020 / 11)"); // S_even = 0, S_odd = 2+9=11, diff = -11

        check_bcd(16'h0010, 1'b0, "0010 (Not mult 11)");
        check_bcd(16'h0012, 1'b0, "0012 (Not mult 11)");
        check_bcd(16'h1000, 1'b0, "1000 (Not mult 11)");
        check_bcd(16'h9998, 1'b0, "9998 (Not mult 11)");

        $display("==================================================================");
        $display("   TEST SUMMARY: Total PASSED = %0d | Total FAILED = %0d", pass_count, fail_count);
        $display("==================================================================");

        $stop;
    end

endmodule
