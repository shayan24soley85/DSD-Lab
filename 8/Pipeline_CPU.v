module Complex_ALU (
    input clk,
    input rst,
    input start,
    input [1:0] op,
    input signed [7:0] Ar, Ai, Br, Bi,
    output reg signed [15:0] Cr, Ci,
    output reg ready
);

    localparam IDLE          = 3'd0;
    localparam ADD_SUB_R     = 3'd1;
    localparam ADD_SUB_I     = 3'd2;
    localparam MUL_RR        = 3'd3;
    localparam MUL_II        = 3'd4;
    localparam MUL_RI_SUB_R  = 3'd5;
    localparam MUL_IR_SAVE_R = 3'd6;
    localparam FINISH        = 3'd7;

    reg signed [15:0] add_in1, add_in2;
    reg add_sub;
    wire signed [15:0] add_out;
    assign add_out = add_sub ? (add_in1 - add_in2) : (add_in1 + add_in2);

    reg signed [7:0] mul_in1, mul_in2;
    wire signed [15:0] mul_out;
    assign mul_out = mul_in1 * mul_in2;

    reg [2:0] state;
    reg signed [15:0] temp1, temp2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ready <= 0;
            Cr <= 0;
            Ci <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 0;
                    if (start) begin
                        if (op == 1 || op == 2) state <= ADD_SUB_R;
                        else if (op == 3) state <= MUL_RR;
                    end
                end
                ADD_SUB_R: begin
                    Cr <= add_out;
                    state <= ADD_SUB_I;
                end
                ADD_SUB_I: begin
                    Ci <= add_out;
                    ready <= 1;
                    state <= IDLE;
                end
                MUL_RR: begin
                    temp1 <= mul_out;
                    state <= MUL_II;
                end
                MUL_II: begin
                    temp2 <= mul_out;
                    state <= MUL_RI_SUB_R;
                end
                MUL_RI_SUB_R: begin
                    Cr <= add_out;
                    temp1 <= mul_out;
                    state <= MUL_IR_SAVE_R;
                end
                MUL_IR_SAVE_R: begin
                    temp2 <= mul_out;
                    state <= FINISH;
                end
                FINISH: begin
                    Ci <= add_out;
                    ready <= 1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always @(*) begin
        add_in1 = 0; add_in2 = 0; add_sub = 0;
        mul_in1 = 0; mul_in2 = 0;
        
        case (state)
            ADD_SUB_R: begin
                add_in1 = {{8{Ar[7]}}, Ar};
                add_in2 = {{8{Br[7]}}, Br};
                if (op == 2) add_sub = 1;
                else add_sub = 0;
            end
            ADD_SUB_I: begin
                add_in1 = {{8{Ai[7]}}, Ai};
                add_in2 = {{8{Bi[7]}}, Bi};
                if (op == 2) add_sub = 1;
                else add_sub = 0;
            end
            MUL_RR: begin
                mul_in1 = Ar; mul_in2 = Br;
            end
            MUL_II: begin
                mul_in1 = Ai; mul_in2 = Bi;
            end
            MUL_RI_SUB_R: begin
                add_in1 = temp1; add_in2 = temp2; add_sub = 1;
                mul_in1 = Ar; mul_in2 = Bi;
            end
            MUL_IR_SAVE_R: begin
                mul_in1 = Ai; mul_in2 = Br;
            end
            FINISH: begin
                add_in1 = temp1; add_in2 = temp2; add_sub = 0;
            end
        endcase
    end
endmodule

module Memory_32 (
    input clk,
    input [4:0] addr,
    output reg [15:0] data_out
);
    reg [15:0] mem [0:31];
    
    initial begin
        mem[0] = 16'h4000;
        mem[1] = 16'h8000;
        mem[2] = 16'hC000;
        mem[3] = 16'h4000;
        mem[4] = 16'hC000;
        mem[5] = 16'h0000;
    end
    
    always @(posedge clk) begin
        data_out <= mem[addr];
    end
endmodule

module Pipeline_CPU (
    input clk,
    input rst,
    input signed [7:0] data_Ar, data_Ai, data_Br, data_Bi, 
    output signed [15:0] result_r,
    output signed [15:0] result_i,
    output done,
    output [4:0] current_pc
);
    reg [4:0] pc;
    wire [15:0] instr;
    reg [15:0] if_id_instr;
    reg id_ex_start;
    reg [1:0] id_ex_op;
    reg signed [7:0] id_ex_Ar, id_ex_Ai, id_ex_Br, id_ex_Bi;
    wire alu_ready;
    wire [15:0] alu_Cr, alu_Ci;

    Memory_32 u_mem (
        .clk(clk),
        .addr(pc),
        .data_out(instr)
    );

    Complex_ALU u_alu (
        .clk(clk),
        .rst(rst),
        .start(id_ex_start),
        .op(id_ex_op),
        .Ar(id_ex_Ar),
        .Ai(id_ex_Ai),
        .Br(id_ex_Br),
        .Bi(id_ex_Bi),
        .Cr(alu_Cr),
        .Ci(alu_Ci),
        .ready(alu_ready)
    );

    assign result_r = alu_Cr;
    assign result_i = alu_Ci;
    assign done = alu_ready;
    assign current_pc = pc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;
            if_id_instr <= 0;
            id_ex_start <= 0;
        end else begin
            if (alu_ready || pc == 0) begin
                if_id_instr <= instr;
                id_ex_op <= instr[15:14];
                
                if (instr[15:14] != 0) begin
                    pc <= pc + 1;
                    id_ex_start <= 1;
                    id_ex_Ar <= data_Ar; 
                    id_ex_Ai <= data_Ai;
                    id_ex_Br <= data_Br; 
                    id_ex_Bi <= data_Bi;
                end else begin
                    id_ex_start <= 0;
                end
            end else begin
                id_ex_start <= 0;
            end
        end
    end
endmodule