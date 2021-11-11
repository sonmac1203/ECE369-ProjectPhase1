`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2021 12:54:44 AM
// Design Name: 
// Module Name: ZeroExtension
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ZeroExtension(in, out);
    input [4:0] in;
    output reg [31:0] out;
    
    initial begin
        out <= 32'b0;
    end
    
    always @(*) begin
        out <= {27'b0, in};
    end
endmodule
