`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: Mux4_tb
/////////////////////////////////////////////////////////////////
module Mux4_tb(
    );
    reg [1:0] Select;
    reg [3:0] I;
    wire  led0;

    Mux4 Mux4_1 (led0, I, Select[1], Select[0] );

initial begin
	I= 4'b1011;
	Select = 2'b00;
	#20;	
	Select = 2'b01;
	#20;
	Select = 2'b10;
	#20;
	Select = 2'b11;
	#20;
	I= 4'b1010;
	Select = 2'b00;
	#20;
	I= 4'b1001;
	Select = 2'b01;
	#20;
	I= 4'b1001;
	Select = 2'b10;
	#20;
	I= 4'b1111;
	Select = 2'b11;
	#20;
	I= 4'b0011;
	Select = 2'b00;
	#20
	$finish;
	end
endmodule
