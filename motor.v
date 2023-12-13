// This module take "mode" input and control two motors accordingly.
// clk should be 100MHz for PWM_gen module to work correctly.
// You can modify / add more inputs and outputs by yourself.
module motor(
    input clk,
    input rst,
    input [1:0]l_mode,
	input [1:0]r_mode,
    output [1:0]pwm,
    output [1:0]r_IN,
    output [1:0]l_IN
);

    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, 10'd700, left_pwm);
    motor_pwm m1(clk, rst, 10'd700, right_pwm);

    assign pwm = {left_pwm,right_pwm};

    // TODO: trace the rest of motor.v and control the speed and direction of the two motors
	// assign l_IN = (l_mode == 0 || l_mode == 3 ? 0 : (l_mode == 1 ? 1 : 2));
	// assign r_In = (r_mode == 0 || r_mode == 3 ? 0 : (r_mode == 1 ? 1 : 2)); 
	assign l_IN = 1;
	assign r_IN = 1;

    
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty cycle
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end else if (count < count_max) begin
            count <= count + 1;
			if(count <= count_duty)
				PWM <= 1;
			else	
				PWM <= 0;
            // TODO: set <PWM> accordingly
        end else begin
            count <= 0;
            PWM <= 0;
        end
    end
endmodule

