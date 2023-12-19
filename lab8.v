module Lab8(
    input clk,
    input rst,
    input echo,
    input left_track,
    input right_track,
    input mid_track,
    output trig,
    output IN1,
    output IN2,
    output IN3, 
    output IN4,
    output left_pwm,
    output right_pwm,
    output [15:0] _led
    // You may modify or add more input/ouput yourself.
);
    // We have connected the motor and sonic_top modules in the template file for you.
    // TODO: control the motors with the information you get from ultrasonic sensor and 3-way track sensor.
	/*
		mode =
		0: motor off
		1: forward
		2: backward
		3: motor off
	*/

	reg [1:0] r_mode, l_mode;

    motor A(
        .clk(clk),
        .rst(rst),
        .l_mode(l_mode),
		.r_mode(r_mode),
        .pwm({left_pwm, right_pwm}),
        .l_IN({IN1, IN2}),
        .r_IN({IN3, IN4})
    );

    reg stop = 0;
    wire trig;
    wire [19:0] distance;
    sonic_top B(
        .clk(clk),
        .rst(rst),
        .Echo(echo),
        .Trig(trig),
        .distance(distance)
    );

    always @(*) begin
        if (distance <= 15) begin
            stop <= 1;
        end else begin
            stop <= 0;
        end
    end

	always@(posedge clk) begin
        // sonic part here
        if (stop) begin
            l_mode <= 0;
            r_mode <= 0;
        end else begin
            if(left_track ^ right_track == 0) begin
                if(left_track) begin
                    l_mode <= 1;
                    r_mode <= 1;
                end
                else begin
                    l_mode <= (mid_track ? 1 : 0);
                    r_mode <= (mid_track ? 1 : 0);
                end
            end
            else begin
                l_mode <= (right_track ? 1 : 0);
                r_mode <= (!right_track ? 1 : 0);
            end
        end
	end

    // use led to check track sensor
    assign _led = {stop, 12'b0, left_track, mid_track, right_track};

endmodule
