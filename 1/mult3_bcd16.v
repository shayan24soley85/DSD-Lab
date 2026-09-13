module bcd_mod3 (
    input  wire [3:0] in,
    output wire [1:0] r
);
    wire A, B, C, D;
    assign A = in[3];
    assign B = in[2];
    assign C = in[1];
    assign D = in[0];

    wire A_n, B_n, C_n, D_n;
    not (A_n, A);
    not (B_n, B);
    not (C_n, C);
    not (D_n, D);

    wire m1, m4, m7;
    and (m1, A_n, B_n, C_n, D);
    and (m4, A_n, B,   C_n, D_n);
    and (m7, A_n, B,   C,   D);
    or  (r[0], m1, m4, m7);

    wire m2, m5, m8;
    and (m2, A_n, B_n, C,   D_n);
    and (m5, A_n, B,   C_n, D);
    and (m8, A,   B_n, C_n, D_n);
    or  (r[1], m2, m5, m8);

endmodule


module mod3_add (
    input  wire [1:0] X,
    input  wire [1:0] Y,
    output wire [1:0] Z
);
    wire X1_n, X0_n, Y1_n, Y0_n;
    not (X1_n, X[1]);
    not (X0_n, X[0]);
    not (Y1_n, Y[1]);
    not (Y0_n, Y[0]);

    // Z[0] is 1 for (X=00, Y=01), (X=01, Y=00), (X=10, Y=10)
    wire z0_t1, z0_t2, z0_t3;
    and (z0_t1, X1_n, X0_n, Y1_n, Y[0]);
    and (z0_t2, X1_n, X[0], Y1_n, Y0_n);
    and (z0_t3, X[1], X0_n, Y[1], Y0_n);
    or  (Z[0], z0_t1, z0_t2, z0_t3);

    // Z[1] is 1 for (X=00, Y=10), (X=01, Y=01), (X=10, Y=00)
    wire z1_t1, z1_t2, z1_t3;
    and (z1_t1, X1_n, X0_n, Y[1], Y0_n);
    and (z1_t2, X1_n, X[0], Y1_n, Y[0]);
    and (z1_t3, X[1], X0_n, Y1_n, Y0_n);
    or  (Z[1], z1_t1, z1_t2, z1_t3);

endmodule

module mult3_bcd16 (
    input  wire [15:0] BCD,
    output wire Y
);
    wire [1:0] r3, r2, r1, r0;

    bcd_mod3 u3 (BCD[15:12], r3);
    bcd_mod3 u2 (BCD[11:8],  r2);
    bcd_mod3 u1 (BCD[7:4],   r1);
    bcd_mod3 u0 (BCD[3:0],   r0);

    wire [1:0] sum01, sum23, sum_total;

    mod3_add add01   (r0,    r1,    sum01);
    mod3_add add23   (r2,    r3,    sum23);
    mod3_add add_tot (sum01, sum23, sum_total);

    wire s1_n, s0_n;
    not (s1_n, sum_total[1]);
    not (s0_n, sum_total[0]);
    and (Y, s1_n, s0_n);

endmodule
