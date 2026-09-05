`timescale 1ns/1ps

module waiting_room_tb;

    reg Clk, Clr, IN_sensor, OUT_sensor, Ent, T;
    wire Open, Close;
    wire [3:0] Count;
    integer i;

    Waiting_Room uut (
        .Clk(Clk), .Clr(Clr), .IN_sensor(IN_sensor), .OUT_sensor(OUT_sensor), 
        .Ent(Ent), .T(T), .Open(Open), .Close(Close), .Count(Count)
    );

    always #10 Clk = ~Clk; 

    initial begin
      
        Clk = 0; Clr = 0; IN_sensor = 0; OUT_sensor = 0; Ent = 0; T = 0;
        #25 Clr = 1; 
       
        #15; 
        
        Ent = 1; T = 0; 
        #20 Ent = 0;
        
        #20 Ent = 1; T = 1;
        #20 Ent = 0; T = 0;
        #20 IN_sensor = 1; 
        #20 IN_sensor = 0; 
        
        #20 Ent = 1; T = 1;
        #20 Ent = 0; T = 0;
        #20 IN_sensor = 1; 
        #20 IN_sensor = 0; 

        #20 Ent = 1; T = 1;
        #20 Ent = 0; T = 0;
        #20 IN_sensor = 1; OUT_sensor = 1; 
        #20 IN_sensor = 0; OUT_sensor = 0;

        #20 OUT_sensor = 1; 
        #20 OUT_sensor = 0;

        #20 OUT_sensor = 1; 
        #20 OUT_sensor = 0;

        for (i = 0; i < 15; i = i + 1) begin
            #20 Ent = 1; T = 1;
            #20 Ent = 0; T = 0;
            #20 IN_sensor = 1; 
            #20 IN_sensor = 0;
        end

        #20 Ent = 1; T = 1;
        #20 Ent = 0; T = 0;
        #40;

        #50 $stop;
    end

endmodule