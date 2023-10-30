`timescale 1ns / 1ps

module vga_sync(clk, hsync, vsync, xCount, yCount, inDisplay);

	input clk;
	
	output hsync, vsync, inDisplay; //
	output reg [-:0] xCount; //how many bits minimum do we need to represent width + wblank area?
	output reg [-:0] yCount; //how many bits minimum  do we need to represent height + hblank area?
	
	//Put in the clk_wiz IP here
	
	
	//You will likely need multiple always blocks. When should changes in the horizontal count occur? 
	always @(posedge ---) begin
	//y should be incremented when we know x has reached the right-most position
	//both, horizontal and vertical should not only consider display area but blanking period as well, when counting!
	end
	
	assign hsync = ~((--- && ---));
	assign vsync = ~((--- && ---));
	
	//This should be true if our counts are within our display areas (e.g are x,y in the horizontal display?)
	assign inDisplay = () ? 1'b1 : 1'b0;


endmodule