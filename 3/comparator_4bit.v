
module cascadable_1bit_comparator (
    input  wire a,
    input  wire b,
    input  wire gt_in,  
    input  wire eq_in,  
    input  wire lt_in,  
    output wire gt_out,
    output wire eq_out,
    output wire lt_out
);

    assign gt_out = gt_in | (eq_in & (a & ~b));
    assign lt_out = lt_in | (eq_in & (~a & b));
    assign eq_out = eq_in & (a ~^ b);

endmodule


module comparator_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire       A_gt_B,
    output wire       A_eq_B,
    output wire       A_lt_B
);

    wire [2:0] gt_chain;
    wire [2:0] eq_chain;
    wire [2:0] lt_chain;

    cascadable_1bit_comparator comp3 (
        .a(A[3]),
        .b(B[3]),
        .gt_in(1'b0),
        .eq_in(1'b1),
        .lt_in(1'b0),
        .gt_out(gt_chain[2]),
        .eq_out(eq_chain[2]),
        .lt_out(lt_chain[2])
    );

    cascadable_1bit_comparator comp2 (
        .a(A[2]),
        .b(B[2]),
        .gt_in(gt_chain[2]),
        .eq_in(eq_chain[2]),
        .lt_in(lt_chain[2]),
        .gt_out(gt_chain[1]),
        .eq_out(eq_chain[1]),
        .lt_out(lt_chain[1])
    );

    cascadable_1bit_comparator comp1 (
        .a(A[1]),
        .b(B[1]),
        .gt_in(gt_chain[1]),
        .eq_in(eq_chain[1]),
        .lt_in(lt_chain[1]),
        .gt_out(gt_chain[0]),
        .eq_out(eq_chain[0]),
        .lt_out(lt_chain[0])
    );

    cascadable_1bit_comparator comp0 (
        .a(A[0]),
        .b(B[0]),
        .gt_in(gt_chain[0]),
        .eq_in(eq_chain[0]),
        .lt_in(lt_chain[0]),
        .gt_out(A_gt_B),
        .eq_out(A_eq_B),
        .lt_out(A_lt_B)
    );

endmodule
