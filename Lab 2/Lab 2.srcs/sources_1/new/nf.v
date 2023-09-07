`timescale 1ns / 1ps

// 2:1 Mux module
module Mux2 (
        input wire sel,
        I0,
        I1,
        output reg Y );

    always @ (I0, I1, sel)
    begin
        if (sel == 0)
        begin
            Y = I0;
        end
        else
        begin
            Y = I1;
        end
    end

endmodule

// Module for Mux 4:1
module Mux4 (y, In, Sel_A, Sel_B);
    output y;
    input [3:0] In;
    input  Sel_A,Sel_B;
    wire [1:0] out;

    // Instantiate Mux2 module 3 times to create a 4:1 Mux

    Mux2 mux1 ( .sel(Sel_A), .I0(In[0]), .I1(In[1]), .Y(out[0]) );
    Mux2 mux2 ( .sel(Sel_A), .I0(In[2]), .I1(In[3]), .Y(out[1]) );
    Mux2 mux3 ( .sel(Sel_B), .I0(out[0]), .I1(out[1]), .Y(y) );

endmodule