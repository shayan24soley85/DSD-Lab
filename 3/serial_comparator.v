
module serial_comparator (
    input  wire clk,
    input  wire reset,
    input  wire a,
    input  wire b,
    output wire gt,
    output wire eq,
    output wire lt 
);

    wire next_gt;
    wire next_lt;

    wire q_gt_master, q_gt;
    wire q_lt_master, q_lt;


    assign next_gt = q_gt | (~q_gt & ~q_lt & (a & ~b));
    assign next_lt = q_lt | (~q_gt & ~q_lt & (~a & b));


    assign q_gt_master = reset ? 1'b0 : (~clk ? next_gt : q_gt_master);
    assign q_gt        = reset ? 1'b0 : ( clk ? q_gt_master : q_gt);


    assign q_lt_master = reset ? 1'b0 : (~clk ? next_lt : q_lt_master);
    assign q_lt        = reset ? 1'b0 : ( clk ? q_lt_master : q_lt);

    assign gt = q_gt;
    assign lt = q_lt;
    assign eq = ~q_gt & ~q_lt;

endmodule

