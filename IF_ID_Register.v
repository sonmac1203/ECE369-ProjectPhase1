`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - IF_ID_Register.v
// Description - Create a Verilog file for the IF/ID Register of the pipelined version
//////////////////////////////////////////////////////////////////////////////////////

module IF_ID_Register(Clk, InInstruction, OutInstruction, InPCAddResult, OutPCAddResult,
                      IF_ID.Write); // Added for Hazard Detection
    
    input IF_ID.Write;
    input Clk;
    input [31:0] InInstruction, InPCAddResult;

    output reg [31:0] OutInstruction, OutPCAddResult;

    initial begin
        OutInstruction <= 0;
        OutPCAddResult <= 0;
    end

    always @(posedge Clk) begin
        if (IF_ID.Write == 1) begin
            OutInstruction <= InInstruction;
            OutPCAddResult <= InPCAddResult;
        end
    end
endmodule

