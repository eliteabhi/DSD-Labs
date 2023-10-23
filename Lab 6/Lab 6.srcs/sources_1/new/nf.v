`timescale 1ns / 1ps

module nf(CLK, SSEG_CA, SSEG_AN, SW);
input CLK;
input [3:0] SW;
output [7:0] SSEG_CA;
output reg [7:0] SSEG_AN;

reg [31:0] Count,Clock_Counter;
reg [5:0] SEL;
reg [7:0] DigR;
reg [3:0] Dig_IN;
reg Clk_Multi;
parameter width2 = 10000;

always@(posedge CLK) begin 
Clock_Counter <= Clock_Counter + 1;
if(Clock_Counter == width2) Clk_Multi <= !Clk_Multi;
if(Clock_Counter == width2) Clock_Counter <= 0;
end

always@(posedge Clk_Multi) begin 
    Count <= Count + 1;
    DigR <= 8'hA4 + SW;
    case(Count)
        0 : begin
                SSEG_AN <= 8'b11111110;
                Dig_IN <= 5;
            end
        1 : begin
                SSEG_AN <= 8'b11111101;
                Dig_IN <= 10;
            end
        2 : begin
                SSEG_AN <= 8'b11111011;
                Dig_IN <= 7;
            end
        3 : begin
                SSEG_AN <= 8'b11110111;
                Dig_IN <= 3 + SW;
            end
        4 : begin
                SSEG_AN <= 8'b11101111;
                Dig_IN <= 15;
            end
        5 : begin
                SSEG_AN <= 8'b11011111;
                Dig_IN <= DigR[3:0];
            end
        6 : begin
                SSEG_AN <= 8'b10111111;
                Dig_IN <= DigR[7:4];
            end
        7 : begin
                SSEG_AN <= 8'b01111111;
                Dig_IN <= 2;
                Count <= 0;
            end
   endcase
end
            
Digit_Set_Segs IN0(Dig_IN,0,SSEG_CA);
               
endmodule

module Digit_Set_Segs(
input [3:0] Digit,
input DP,
output [7:0] Cathodes);

reg [7:0]SSEG_CA;
assign Cathodes = {(~DP),SSEG_CA[6:0]};

always@(Digit)begin
case (Digit)
    4'h0: SSEG_CA = ~(8'b00111111);
    4'h1: SSEG_CA = ~(8'b00000110);
    4'h2: SSEG_CA = ~(8'b01011011);
    4'h3: SSEG_CA = ~(8'b01001111);
    4'h4: SSEG_CA = ~(8'b01100110);
    4'h5: SSEG_CA = ~(8'b01101101);
    4'h6: SSEG_CA = ~(8'b01111101);
    4'h7: SSEG_CA = ~(8'b00000111);
    4'h8: SSEG_CA = ~(8'b01111111);
    4'h9: SSEG_CA = ~(8'b01100111);
    4'hA: SSEG_CA = ~(8'b01110111);
    4'hB: SSEG_CA = ~(8'b01111100);
    4'hC: SSEG_CA = ~(8'b00111001);
    4'hD: SSEG_CA = ~(8'b01011110);
    4'hE: SSEG_CA = ~(8'b01111001);
    4'hF: SSEG_CA = ~(8'b01110001);
    default: SSEG_CA = ~(8'b01001001);
   endcase
   end
  endmodule
