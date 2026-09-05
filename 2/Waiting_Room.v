module up_down_counter (
    input U, Clk, Clr, Enable,
    output reg [3:0] Count
);
  
    always @(posedge Clk or negedge Clr) begin
        if (~Clr) 
            Count <= 4'b0000;
        else if (Enable) begin
            if (U) 
                Count <= Count + 1;
            else 
                Count <= Count - 1;
        end
    end
endmodule

module Waiting_Room (
    input Clk, Clr, IN_sensor, OUT_sensor, Ent, T,
    output reg Open, 
    output Close,
    output [3:0] Count
);
    
    wire Enable;
    wire U;
    
    assign Enable = IN_sensor ^ OUT_sensor;
    assign U = IN_sensor; 
    
    up_down_counter u1 (
        .U(U), 
        .Clk(Clk), 
        .Clr(Clr), 
        .Enable(Enable), 
        .Count(Count)
    );
    
    assign Close = (Count == 0) ? 1'b1 : 1'b0;
    
   
    always @(posedge Clk or negedge Clr) begin
        if (~Clr)
            Open <= 1'b0;
      
        else if (IN_sensor)
            Open <= 1'b0;
        else if (Ent && T && (Count < 15))
            Open <= 1'b1;
    end
endmodule