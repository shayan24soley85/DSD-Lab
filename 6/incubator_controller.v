module incubator_controller (
    input  wire        clk,
    input  wire        rst_n,
    input  wire signed [7:0] temp,
    output reg         heater,
    output reg         cooler,
    output reg  [3:0]  crs
);

    localparam MAIN_S1_IDLE   = 2'b00;
    localparam MAIN_S2_COOL   = 2'b01;
    localparam MAIN_S3_HEAT   = 2'b10;

    localparam FAN_OUT = 2'b00;
    localparam FAN_S1  = 2'b01;
    localparam FAN_S2  = 2'b10;
    localparam FAN_S3  = 2'b11;

    reg [1:0] main_state, next_main_state;
    reg [1:0] fan_state,  next_fan_state;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            main_state <= MAIN_S1_IDLE;
            fan_state  <= FAN_OUT;
        end else begin
            main_state <= next_main_state;
            fan_state  <= next_fan_state;
        end
    end


    always @(*) begin
        next_main_state = main_state;
        case (main_state)
            MAIN_S1_IDLE: begin
                if (temp > 8'sd35)
                    next_main_state = MAIN_S2_COOL;
                else if (temp < 8'sd15)
                    next_main_state = MAIN_S3_HEAT;
            end

            MAIN_S2_COOL: begin
                if (temp < 8'sd25)
                    next_main_state = MAIN_S1_IDLE;
            end

            MAIN_S3_HEAT: begin
                if (temp > 8'sd30)
                    next_main_state = MAIN_S1_IDLE;
            end

            default: next_main_state = MAIN_S1_IDLE;
        endcase
    end


    always @(*) begin
        if (main_state != MAIN_S2_COOL) begin
            next_fan_state = FAN_OUT;
        end else begin
            next_fan_state = fan_state;
            case (fan_state)
                FAN_OUT: begin
                    if (temp > 8'sd35)
                        next_fan_state = FAN_S1;
                end

                FAN_S1: begin
                    if (temp < 8'sd25)
                        next_fan_state = FAN_OUT;
                    else if (temp > 8'sd40)
                        next_fan_state = FAN_S2;
                end

                FAN_S2: begin
                    if (temp < 8'sd35)
                        next_fan_state = FAN_S1;
                    else if (temp > 8'sd45)
                        next_fan_state = FAN_S3;
                end

                FAN_S3: begin
                    if (temp < 8'sd40)
                        next_fan_state = FAN_S2;
                end

                default: next_fan_state = FAN_OUT;
            endcase
        end
    end


    always @(*) begin
        case (main_state)
            MAIN_S1_IDLE: begin
                heater = 1'b0;
                cooler = 1'b0;
            end
            MAIN_S2_COOL: begin
                heater = 1'b0;
                cooler = 1'b1;
            end
            MAIN_S3_HEAT: begin
                heater = 1'b1;
                cooler = 1'b0;
            end
            default: begin
                heater = 1'b0;
                cooler = 1'b0;
            end
        endcase

        case (fan_state)
            FAN_S1:  crs = 4'd4;
            FAN_S2:  crs = 4'd6;
            FAN_S3:  crs = 4'd8;
            default: crs = 4'd0;
        endcase
    end

endmodule
