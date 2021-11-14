`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - IF_ID_Register.v
// Description - Create a Verilog file for the IF/ID Register of the pipelined version
//////////////////////////////////////////////////////////////////////////////////////

module IF_ID_Register(Clk, InInstruction, OutInstruction, InPCAddResult, OutPCAddResult,
                      IF_ID_Write, Flush, Jump); // Added for Hazard Detection
    
    input IF_ID_Write;
    input Flush, Jump;
    input Clk;
    input [31:0] InInstruction, InPCAddResult;

    output reg [31:0] OutInstruction, OutPCAddResult;

    initial begin
        OutInstruction <= 0;
        OutPCAddResult <= 0;
    end

    always @(posedge Clk) begin
        if (IF_ID_Write == 1) begin
            if (Flush == 1 || Jump == 1) begin
                OutInstruction <= 32'd0; // If Flush is high, send a NOP
            end
            else begin
                OutInstruction <= InInstruction;
            end
            OutPCAddResult <= InPCAddResult;
        end
    end
endmodule
