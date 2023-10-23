`timescale 1ns / 1ps

module nf(SEG, AN, CLK100MHZ, SW);
input CLK100MHZ;
input [3:0] SW;
output [7:0] AN;
output [6:0] SEG;

reg [6:0] SEG2;
always@(posedge CLK100MHZ) begin
    case(SW)
             //g f e d c b a
    0 : SEG2 <= 7'b1000000;
    1 : SEG2 <= 7'b1111001;
    2 : SEG2 <= 7'b0100100;
    3 : SEG2 <= 7'b0110000;
    4 : SEG2 <= 7'b0011001;
    5 : SEG2 <= 7'b0010010;
    6 : SEG2 <= 7'b0000011;
    7 : SEG2 <= 7'b1111000;
    8 : SEG2 <= 7'b0000000;
    9 : SEG2 <= 7'b0010000;
    10 : SEG2 <= 7'b0001000;
    11 : SEG2 <= 7'b0000011;
    12 : SEG2 <= 7'b1000110;
    13 : SEG2 <= 7'b0100001;
    14 : SEG2 <= 7'b0000110;
    15 : SEG2 <= 7'b0001110;
    endcase
end

assign AN[0] = 0;
assign AN[7:1] = 7'b1111111;
assign SEG = SEG2;
endmodule
