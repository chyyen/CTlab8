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
    output right_pwm
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

	always@(posedge clk) begin
		if(left_track ^ right_track == 0) begin
			if(left_track) begin
				l_mode <= 1;
				r_mode <= (mid_track ? 1 : 2);
			end
			else begin
				l_mode <= (mid_track ? 2 : 0);
				r_mode <= (mid_track ? 2 : 0);
			end
		end		
		else begin
			l_mode <= (left_track ? 1 : 0);
			r_mode <= (left_track ? 0 : 1);	
		end
	end

    sonic_top B(
        .clk(clk), 
        .rst(rst), 
        .Echo(echo), 
        .Trig(trig),
        .distance(distance)
    );

endmodule
