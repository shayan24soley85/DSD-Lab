module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire axb, aab, axba_cin;
    xor (axb, a, b);
    xor (sum, axb, cin);
    and (aab, a, b);
    and (axba_cin, axb, cin);
    or  (cout, aab, axba_cin);
endmodule


module adder4 (
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire [4:0] S
);
    wire c1, c2, c3;
    full_adder fa0 (A[0], B[0], 1'b0, S[0], c1);
    full_adder fa1 (A[1], B[1], c1,   S[1], c2);
    full_adder fa2 (A[2], B[2], c2,   S[2], c3);
    full_adder fa3 (A[3], B[3], c3,   S[3], S[4]);
endmodule

module add5_const11 (
    input  wire [4:0] In,
    output wire [4:0] Out
);
    wire c1, c2, c3, c4, c_dummy;
    // 11 in 5-bit binary: b0=1, b1=1, b2=0, b3=1, b4=0
    full_adder fa0 (In[0], 1'b1, 1'b0, Out[0], c1);
    full_adder fa1 (In[1], 1'b1, c1,   Out[1], c2);
    full_adder fa2 (In[2], 1'b0, c2,   Out[2], c3);
    full_adder fa3 (In[3], 1'b1, c3,   Out[3], c4);
    full_adder fa4 (In[4], 1'b0, c4,   Out[4], c_dummy);
endmodule

module eq_cmp5 (
    input  wire [4:0] A,
    input  wire [4:0] B,
    output wire eq
);
    wire e0, e1, e2, e3, e4;
    xnor (e0, A[0], B[0]);
    xnor (e1, A[1], B[1]);
    xnor (e2, A[2], B[2]);
    xnor (e3, A[3], B[3]);
    xnor (e4, A[4], B[4]);
    and  (eq, e0, e1, e2, e3, e4);
endmodule

module mult11_bcd16 (
    input  wire [15:0] BCD,
    output wire Y
);
    wire [4:0] S_even; // D0 + D2
    wire [4:0] S_odd;  // D1 + D3

    adder4 add_even (BCD[3:0],  BCD[11:8],  S_even);
    adder4 add_odd  (BCD[7:4],  BCD[15:12], S_odd);

    wire [4:0] S_odd_plus11;
    wire [4:0] S_even_plus11;

    add5_const11 add_p11_1 (S_odd,  S_odd_plus11);
    add5_const11 add_p11_2 (S_even, S_even_plus11);

    wire eq_equal, eq_even_gt, eq_odd_gt;

    eq_cmp5 cmp_eq (S_even, S_odd,         eq_equal);   // S_even == S_odd
    eq_cmp5 cmp_e1 (S_even, S_odd_plus11,  eq_even_gt);  // S_even - S_odd == 11
    eq_cmp5 cmp_o1 (S_odd,  S_even_plus11, eq_odd_gt);   // S_odd - S_even == 11

    or (Y, eq_equal, eq_even_gt, eq_odd_gt);

endmodule
