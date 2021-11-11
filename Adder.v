`timescale 1ns / 1ps

module Adder(A,B,out);
    input [31:0] A,B;
    output reg [31:0] out;
    
    always @(*) begin
        out <= A + B;
    end
endmodule