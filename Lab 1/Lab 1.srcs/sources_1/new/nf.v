`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tutorial
//////////////////////////////////////////////////////////////////////////////////


module Tutorial( input [7:0] SW, output [7:0] LED );
    
    assign LED[0] = ~SW[0];
    assign LED[1] = SW[1] & ~SW[2];
    assign LED[3] = SW[2] & SW[3];
    assign LED[2] = LED[1] | LED[3];
    
    assign LED[7:4] = SW[7:4];
    
endmodule

module Gates( input [15:7] SW, output [14:8] LED );

    assign LED[8] = ~( SW[7] & SW[8] & SW[9] ); // NAND Gate

    assign LED[11] = ~( SW[10] | SW[11] | SW[12] ); // NOR Gate
    
    assign LED[14] = SW[13] ^ SW[14] ^ SW[15]; // XOR Gate

endmodule

module Top( input [15:0] SW, output [14:0] LED );

    Tutorial tut( .SW(SW[7:0]), .LED(LED[7:0]) );
    Gates gates( .SW(SW[15:7]), .LED(LED[14:8]) );

endmodule