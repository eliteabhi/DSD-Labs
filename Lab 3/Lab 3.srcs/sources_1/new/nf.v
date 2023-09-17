`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: counter8
//////////////////////////////////////////////////////////////////////////////////


module counter8(clk,btnU,btnL,btnR,btnD,sw,led);
    input clk;
    input btnU;
    input btnL;
    input btnR;
    input btnD;
    input [15:8] sw;
    output [15:0] led;

    parameter width = 100000000;

    reg [7:0] Count_Reg; 

    assign led = {sw[15:8], Count_Reg};   
    slow_clock # width IN1 (clk, clk_Slow);

    initial begin
        Count_Reg = 8'b00000000;
    end
   
    always @(posedge clk_Slow) begin
        //No control signals in sensitivity list, thus all are synchrous
        //Note:  if we were to put them in the list they would have to be edges not levels   
        
        if ( btnL ) Count_Reg = sw[15:8];

        if ( btnR ) Count_Reg = 8'b00000000;

        if ( btnU ) Count_Reg = Count_Reg + 8'b1;

        if ( btnD ) Count_Reg = Count_Reg - 8'b1;

    end

endmodule

// This module slows down the 100 Mhz clock to a 2 second period.

module slow_clock(Clk, Clk_Slow);
    parameter size = 100000000;  //added to be used by test bench 
    input Clk;
    output Clk_Slow;
    reg [31:0] counter_out;
    reg Clk_Slow;
    initial begin	//Note this will synthesize because we are using an FPGA and not making an IC
        counter_out<= 32'h00000000;
        Clk_Slow <=0;
    end

    //this always block runs on the fast 100MHz clock
    always @(posedge Clk) begin
        counter_out<= counter_out + 32'h00000001;
            
        if (counter_out > size) begin
            counter_out <= 32'h00000000;
            Clk_Slow <= !Clk_Slow;
        end
    end

endmodule
