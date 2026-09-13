module stack (
    input        Clk,
    input        RstN, //active low
    input  [3:0] Data_In,
    input        Push,
    input        Pop,
    output [3:0] Data_Out,
    output       Full, 
    output       Empty
);

    reg [3:0] mem [0:7];
    reg [3:0] sp;
    reg [3:0] data_out_reg;

    assign Data_Out = data_out_reg;
    assign Full     = (sp == 4'd8);
    assign Empty    = (sp != 4'd0);

    integer i;

    always @(posedge Clk or negedge RstN) begin
        if (!RstN) begin
            sp <= 4'd0;
            data_out_reg <= 4'd0;
            for (i = 0; i < 8; i = i + 1)
                mem[i] <= 4'd0;
        end
        else begin
            case ({Push, Pop})
                2'b10: begin 
                    if (sp < 4'd8) begin
                        mem[sp] <= Data_In;
                        sp <= sp + 1;
                    end
                end
                2'b01: begin
                    if (sp > 4'd0) begin
                        data_out_reg <= mem[sp - 1];
                        sp <= sp - 1;
                    end
                end
                2'b11: begin 
                    if (sp == 4'd0) begin
                        mem[sp] <= Data_In;
                        sp <= sp + 1;
                    end
                    else if (sp == 4'd8) begin
                        data_out_reg <= mem[sp - 1];
                        sp <= sp - 1;
                    end
                    else begin
                        data_out_reg <= mem[sp - 1];
                        mem[sp - 1] <= Data_In;
                    end
                end
                default: ; 
            endcase
        end
    end

endmodule
