`timescale 1ns / 1ps

module vga_top(clk, vga_vsync, vga_hsync, red, green, blue);
    input clk;
    output vga_vsync, vga_hsync;
    output [3:0] red,green,blue; //4 bits of RGB color
    
    wire inDisplay, slow_clk;
    wire [9:0] x_pos; //800 = 640 + 96 + 16 + 48
    wire [9:0] y_pos; //525  = 480 + 2

    vga_sync v1(---); //fill in the parameters

    //fill in conditions here. When do you want a color to display? Remember to also consider the display area!
    assign red = (---) ? 4'hF : 4'h0;
    assign green = (---) ? 4'hF : 4'h0;
    assign blue = (---) ? 4'hF : 4'h0;

endmodule
