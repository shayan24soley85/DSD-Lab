module datapath (
    input clk, rst,
    input [7:0] M_in, Q_in,
    input load, shift, add_sub_en, sub_en, sel_2m,
    output [2:0] q_eval,
    output [15:0] result
);
    reg [9:0] A;
    reg [7:0] M, Q;
    reg Q_minus_1;

    wire [9:0] M_ext = {{2{M[7]}}, M};
    wire [9:0] M_val = sel_2m ? {{1{M[7]}}, M, 1'b0} : M_ext;
    wire [9:0] next_A = sub_en ? (A - M_val) : (A + M_val);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            M <= 0;
            Q <= 0;
            Q_minus_1 <= 0;
        end else if (load) begin
            A <= 0;
            M <= M_in;
            Q <= Q_in;
            Q_minus_1 <= 0;
        end else if (add_sub_en) begin
            A <= next_A;
        end else if (shift) begin
            A <= {A[9], A[9], A[9:2]};
            Q <= {A[1:0], Q[7:2]};
            Q_minus_1 <= Q[1];
        end
    end

    assign q_eval = {Q[1:0], Q_minus_1};
    assign result = {A[7:0], Q};
endmodule

module controller (
    input clk, rst, start,
    input [2:0] q_eval,
    output reg load, add_sub_en, sub_en, sel_2m, shift, ready
);
    reg [2:0] state, next_state;
    reg [2:0] count;
    reg inc_count, clr_count;

    localparam IDLE = 3'd0, CHECK = 3'd1, CALC = 3'd2, SHIFT = 3'd3, DONE = 3'd4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            count <= 0;
        end else begin
            state <= next_state;
            if (clr_count) count <= 0;
            else if (inc_count) count <= count + 1;
        end
    end

    always @(*) begin
        next_state = state;
        load = 0; add_sub_en = 0; sub_en = 0; sel_2m = 0; shift = 0; ready = 0;
        inc_count = 0; clr_count = 0;

        case (state)
            IDLE: begin
                if (start) begin
                    load = 1;
                    clr_count = 1;
                    next_state = CHECK;
                end
            end
            CHECK: begin
                if (q_eval == 3'b000 || q_eval == 3'b111) begin
                    next_state = SHIFT;
                end else begin
                    next_state = CALC;
                end
            end
            CALC: begin
                add_sub_en = 1;
                if (q_eval == 3'b001 || q_eval == 3'b010) begin
                    sub_en = 0; sel_2m = 0;
                end else if (q_eval == 3'b011) begin
                    sub_en = 0; sel_2m = 1;
                end else if (q_eval == 3'b100) begin
                    sub_en = 1; sel_2m = 1;
                end else if (q_eval == 3'b101 || q_eval == 3'b110) begin
                    sub_en = 1; sel_2m = 0;
                end
                next_state = SHIFT;
            end
            SHIFT: begin
                shift = 1;
                inc_count = 1;
                if (count == 3) next_state = DONE;
                else next_state = CHECK;
            end
            DONE: begin
                ready = 1;
                if (!start) next_state = IDLE;
            end
        endcase
    end
endmodule

module booth_mult (
    input clk, rst, start,
    input [7:0] M_in, Q_in,
    output [15:0] result,
    output ready
);
    wire load, shift, add_sub_en, sub_en, sel_2m;
    wire [2:0] q_eval;

    datapath dp (
        .clk(clk),
        .rst(rst),
        .M_in(M_in),
        .Q_in(Q_in),
        .load(load),
        .shift(shift),
        .add_sub_en(add_sub_en),
        .sub_en(sub_en),
        .sel_2m(sel_2m),
        .q_eval(q_eval),
        .result(result)
    );

    controller ctrl (
        .clk(clk),
        .rst(rst),
        .start(start),
        .q_eval(q_eval),
        .load(load),
        .add_sub_en(add_sub_en),
        .sub_en(sub_en),
        .sel_2m(sel_2m),
        .shift(shift),
        .ready(ready)
    );
endmodule