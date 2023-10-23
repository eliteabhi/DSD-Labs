`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:56 10/28/2013 
// Design Name: 
// Module Name:    Non-seq4bitctr 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NS4bitctr (
    input Fast_Clk,
    output A,
    output B,
    output C,
    output D,
    input Start
    );
	reg [3:0] State;
	reg [3:0] LEDs;
	reg [3:0] Next_State;
// code to slow down the 50MHz clock
	reg [26:0] counter_out;
	reg Clk_Slow, Looper;

	initial begin
	counter_out <= 26'h0000000;
	State <= 4'b0000;
	Next_State <= 4'b0000;
	LEDs <= 4'b0001;
	end
// may need to initilize the FF A,B,C,D TO 0001;
	assign {A,B,C,D} = LEDs;  
   always @(posedge Fast_Clk) begin
		counter_out <=    counter_out + 1;
		if(counter_out == 10'd1000) Clk_Slow <= !Clk_Slow;
	end
// Routine for the counter starts here
	always @(posedge Clk_Slow) begin
			State <= Next_State;
	end
	always @(State, Start )begin
	case (State)
	0:
	
		begin
		if (Start == 1'b0) begin
			Next_State <= 4'b0000;
			LEDs <= 4'b0001;
		end
		else begin
			Next_State <= 4'b0001;
			LEDs <= 4'b0001;
		end
		end
	1:
		begin
		Next_State <= 4'b0010;
		LEDs <= 4'b1010;
		end
	2:
		begin
		Next_State <= 4'b0011;
		LEDs <= 4'b0100;
		end
	3:
		begin
		Next_State <= 4'b0100;
		LEDs <= 4'b1100;
		end
	4:
		begin
		Next_State <= 4'b0101;
		LEDs <= 4'b0111;
		end
	5:
		begin
		Next_State <= 4'b0110;
		LEDs <= 4'b0010;
		end
	6:
		begin
		Next_State <= 4'b0111;
		LEDs <= 4'b1111;
		end
	7:
		begin
		Next_State <= 4'b1000;
		LEDs <= 4'b0110;
		end
	8:
		begin
		Next_State <= 4'b0000;
		LEDs <= 4'b1001;
		end
	endcase
	end
endmodule
