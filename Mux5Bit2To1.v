`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - Mux5Bit2To1.v
// Description - Performs signal multiplexing between 2 5-Bit words.
////////////////////////////////////////////////////////////////////////////////

module Mux5Bit2To1(out, inA, inB, sel);

    output reg [4:0] out;
    
    input [4:0] inA;
    input [4:0] inB;
    input sel;

    /* Fill in the implementation here ... */ 
    always @(inA,inB,sel) begin
        if (sel == 0) begin
            out <= inA;
        end
        else begin
            out <= inB;
        end
    end
endmodule
