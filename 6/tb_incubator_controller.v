`timescale 1ns / 1ps

module tb_incubator_controller;

    reg        clk;
    reg        rst_n;
    reg signed [7:0] temp;

    wire       heater;
    wire       cooler;
    wire [3:0] crs;

    incubator_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .temp(temp),
        .heater(heater),
        .cooler(cooler),
        .crs(crs)
    );

    always #5 clk = ~clk;

    initial begin
	$dumpfile("incubator_waves.vcd");
        $dumpvars(0, tb_incubator_controller);
        $monitor("Time = %0t ns | Temp = %0d C | Heater = %b | Cooler = %b | CRS = %0d RPS",
                 $time, temp, heater, cooler, crs);

        clk   = 0;
        rst_n = 0;
        temp  = 8'sd20;
        #15;
        
        rst_n = 1;
        #10;

        temp = 8'sd10;
        #20;
        
        temp = 8'sd25;
        #20;

        temp = 8'sd32;
        #20;

        temp = 8'sd38;
        #20;

        temp = 8'sd42;
        #20;

        temp = 8'sd48;
        #20;

        temp = 8'sd38;
        #20;

        temp = 8'sd32;
        #20;

        temp = 8'sd22;
        #20;

        temp = -8'sd5;
        #20;

        $display("Simulation Finished Successfully.");
        $stop;
    end

endmodule
