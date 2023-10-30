`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Morton
//
// Create Date: 11/04/2018 11:03:09 PM
// Design Name:
// Module Name: Lab_9
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Lab_9(
    input CLK,
    input [7:0] SW,
    output [15:0] LED,
    output [7:0] SSEG_CA,
    output [7:0] SSEG_AN
    );

    parameter width1 = 100000000;
    parameter width2=10000;


    wire [3:0] GT,LT;
    wire [7:0] Sarray [0:7];    //64 bit 2D array holding desired values for all digits
    wire [63:0] Pass_Array;     // 64 bit 1D array used to pass the 2D array to submodule
    wire [7:0] Seg_val0;         // holding 8 bit cathode values to pass to submodule
    wire Clk_Slow, Clk_Multi;   //Clocks from divider module
    wire [7:0] Seg_valA;         // holding 8 bit cathode values to pass to submodule
    wire [7:0] Seg_valB;
    wire [7:0] Seg_valResult;


    assign LED[7:0] = SW[7:0];   //display the sw settings
    assign LED[12:8]= 1'b0;      //turn off unused leds
    //will assign 13 = LT, 14 = Eq, 15 = GT

Clk_Divide # (width1,width2) IN0 (CLK, Clk_Slow, Clk_Multi);  //Here is the instanitatin Clk div
//We will only use the multiplexer clock

    Comparator IN1 (SW[7],SW[3],1'b0,1'b0,GT[3],LT[3]);
    Comparator IN2 (SW[6],SW[2],1'b0,1'b0,GT[2],LT[2]);
    Comparator IN3 (SW[5],SW[1],1'b0,1'b0,GT[1],LT[1]);
    Comparator IN4 (SW[4],SW[0],1'b0,1'b0,GT[0],LT[0]);

    //Set the seven segment cathods for the patterns for A and B
    Digit_Set_Segs IN5 (SW[3:0],1'b0,Seg_valB);  //the 1'b0 turns off decimal pt
    assign Sarray [0] =  Seg_valB;              //Have to use Seg_val because can't pass 2D array
    Digit_Set_Segs IN6 (SW[7:4],1'b0,Seg_valA);
    assign Sarray [1] =  Seg_valA;
    //Figure out the answer G,L,E to display  G is same as 6
    //Use ?: construct to make it turn out to be combinational
    assign LED[15] = GT[0];
    assign LED [13] = LT[0];
    assign LED [14] = (!GT[3:0] && !LT[3:0]);
    assign Seg_valResult = (GT[3:0])? ~(8'b00111101):((LT[3:0])? ~(8'b00111000): ~(8'b01111001));
    assign Sarray [7]= Seg_valResult;
    //Turn off all segments for the non-used digits
    assign Sarray [2] = 8'hFF;  //MUST USE FF for blakning the digit
    assign Sarray [3] = 8'hFF;
    assign Sarray [4] = 8'hFF;
    assign Sarray [5] = 8'hFF;
    assign Sarray [6] = 8'hFF;

        //Linerize the Sarray
    assign Pass_Array = {Sarray[0],Sarray[1],Sarray[2],Sarray[3],Sarray[4],Sarray[5],Sarray[6],Sarray[7]};

        //Display what is in Sarray at all times
    Display_Digit IN7 (Pass_Array, Clk_Multi, SSEG_CA, SSEG_AN);  //get the display done

endmodule

//*********************************************************************************************
//This is the 1 bit Comparator module
//Takes 1 bit X and 1 bit Y and LTn and GTn and outputs LTn-1 and GTn-1
module Comparator (
    input X,
    input Y,
    input GTn,
    input LTn,
    output reg GTn1,
    output reg LTn1);

    always @(*)
       begin
//        if((X & (~Y)) | GTn)        //if the previous comparator value was greater than
       if(((~X) & Y) | LTn)    // if the previous comparator value was less than
       begin
           LTn1 =1'b1;
           GTn1 =1'b0;
       end
       else if((X & (~Y)) | GTn)        //if the previous comparator value was greater than
//         else if(((~X) & Y) | LTn)    // if the previous comparator value was less than
       begin
           LTn1 =1'b0;
           GTn1 = 1'b1;
       end
       else        // if the previous comparator values were equal to
       begin
          //LTn1 = ;
        //  GTn1 = ;
         LTn1 = 1'b0;
         GTn1 = 1'b0;
       end
       end
endmodule
//***********************************************************************************************
// This module slows down the 100 Mhz clock to a 2 second period. and 1 KHz mult clocks

module Clk_Divide (Clk, Clk_Slow, Clk_multi);
input Clk;
output Clk_Slow,Clk_multi;
reg Clk_Slow;
reg Clk_multi;
parameter size1 = 100000000;
parameter size2 = 10000; //added to be used by test bench

reg [31:0] counter_out1, counter_out2;
	initial begin	//Note this will synthesize because we are using an FPGA and not making an IC
	counter_out1<= 32'h00000000;
	counter_out2<= 32'h00000000;
	Clk_Slow  <= 1'b0;
	Clk_multi <= 1'b0;
	end

//this always block runs on the fast 100MHz clock
always @(posedge Clk) begin
	counter_out1<=    counter_out1 + 32'h00000001;
	counter_out2<=    counter_out2 + 32'h00000001;
	if (counter_out1  > size1) begin
		counter_out1<= 32'h00000000;
		Clk_Slow <= !Clk_Slow;
	end
    if (counter_out2  > size2) begin
       counter_out2<= 32'h00000000;
       Clk_multi <= !Clk_multi;
    end
end
endmodule
//**************************************************************************************
module Digit_Set_Segs(
input [3:0] Digit, //All 16 hex digits decoded
input DP,  //DP=1 means turn on Decmil Point
output [7:0] Cathodes);  //Note bit order Hi to Lo (DP, G,F,E,D,C,B,A)

reg [7:0]SEG_CA;

assign Cathodes = {(~DP),SEG_CA[6:0]};

          always @(Digit)begin
case (Digit)
   4'h0: SEG_CA = ~(8'b00111111);    //Note:  to lite digit, cathode must = 0
   4'h1: SEG_CA = ~(8'b00000110);
   4'h2: SEG_CA = ~(8'b01011011);
   4'h3: SEG_CA = ~(8'b01001111);
   4'h4: SEG_CA = ~(8'b01100110);
   4'h5: SEG_CA = ~(8'b01101101);
   4'h6: SEG_CA = ~(8'b01111101);
   4'h7: SEG_CA = ~(8'b00000111);
   4'h8: SEG_CA = ~(8'b01111111);
   4'h9: SEG_CA = ~(8'b01100111);
   4'hA: SEG_CA = ~(8'b01110111);
   4'hB: SEG_CA = ~(8'b01111100);
   4'hC: SEG_CA = ~(8'b00111001);
   4'hD: SEG_CA = ~(8'b01011110);
   4'hE: SEG_CA = ~(8'b01111001);
   4'hF: SEG_CA = ~(8'b01110001);
   default: SEG_CA = ~(8'b01001001);
 endcase
 end
endmodule
//**************************************************************************************
//This module takes linerized 2D array of cathod segments for all 8 indicators
//Must linerize the 2D array in top module same as un-linerized in this sub-module
//Where all segments are 0 if that indicator digit is blanked
//the multi clock is used to multiplex the 8 indicators with the desired values in the linerized
//2D array.  It makes sure all are off before setting new segment values to avoid streaks
//The multi clock should be a few KHz, anodes and cathods are passed back and should be
//connected to the top port for the indicators.
module Display_Digit (
    input [63:0] Parray,
    input  Clk,
    output reg [7:0] Segments,
    output reg [7:0] AN
    );

    wire [7:0] Cath [0:7];  //array of 8, 8 bit cathode values where Seg [0] is Right indicator
                            // and Seg[7] is Left most indicator cathods
    reg [3:0] i;  // used to count through 16 states to multiplex the 8 displays

    //Now we break out the linerized array
    assign {Cath [0],Cath [1],Cath [2],Cath [3],Cath [4],Cath [5],Cath [6],Cath [7]} = Parray;
    initial begin
    i=4'b0000;
    end

         always @(posedge Clk)begin

          case (i)
           4'h0:
           begin
           AN = ~(8'b00000000);  //All off, set cathodes
           Segments = Cath [0];
           end
           4'h1:AN = ~(8'b00000001);  //Display first indicator on R

           4'h2:
           begin
           AN = ~(8'b00000000);   //All off set next cath
           Segments = Cath [1];
           end
           4'h3:AN = ~(8'b00000010);  //Display 2nd indicator on R

           4'h4:
           begin
           AN = ~(8'b00000000);   //All off set next cath
           Segments = Cath [2];
           end
           4'h5:AN = ~(8'b00000100);  //Display 3rd indicator on R

           4'h6:
           begin
           AN = ~(8'b00000000);   //All off set next cath
           Segments = Cath [3];
           end
           4'h7:AN = ~(8'b00001000);  //Display 4th indicator on R

           4'h8:
           begin
           AN = ~(8'b00000000);   //All off set next cath
           Segments = Cath [4];
           end
           4'h9:AN = ~(8'b00010000);  //Display 5th indicator on R

           4'hA:
           begin
           AN = ~(8'b00000000);   //All off set next cath
           Segments = Cath [5];
           end
           4'hB:AN = ~(8'b00100000);  //Display 3rd indicator on R

           4'hC:
           begin
           AN = ~(8'b00000000);   //All off set next cath
           Segments = Cath [6];
           end
           4'hD:AN = ~(8'b01000000);  //Display 3rd indicator on R

           4'hE:
           begin
           AN = ~(8'b00000000);   //All off set next cath
           Segments = Cath [7];
           end
           4'hF:AN = ~(8'b10000000);  //Display 3rd indicator on R

           default:AN = ~(8'b00000000);
           endcase
           i = i + 4'b0001;
           end
   endmodule
