`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - ID_EX_Register.v
// Description - Create a Verilog file for the ID/EX Register of the pipelined version
//////////////////////////////////////////////////////////////////////////////////////

module ID_EX_Register(Clk, InReadData1, InReadData2, InImmExtended, InRt, InRd,
                      InALUSrc, InRegDst, InRegWrite, InALUOp, InMemRead, InMemWrite, InMemToReg, InBranch, InHalf, InShift,
                      InJrSrc, InJSrc,
                      InPCAddResult, OutPCAddResult,
                      InInstruction25To0, OutInstruction25To0,
                      InZeroExtension, OutZeroExtension,
                      InJump, OutJump,
                      OutReadData1, OutReadData2, OutImmExtended, OutRt, OutRd,
                      OutALUSrc, OutRegDst, OutRegWrite, OutALUOp, OutMemRead, OutMemWrite, OutMemToReg, OutBranch, OutHalf, OutShift,
                      OutJrSrc, OutJSrc);

    input Clk, InALUSrc, InRegDst, InRegWrite, InMemRead, InMemWrite, InMemToReg, InBranch, InShift, InJrSrc, InJSrc;
    input [5:0] InALUOp;
    input [1:0] InHalf;
    input [31:0] InReadData1, InReadData2, InImmExtended, InZeroExtension;
    input [4:0] InRt, InRd;
    input [31:0] InPCAddResult;
    input [25:0] InInstruction25To0;
    input InJump;

    output reg OutALUSrc, OutRegDst, OutRegWrite, OutMemRead, OutMemWrite, OutMemToReg, OutBranch, OutShift, OutJrSrc, OutJSrc;
    output reg [5:0] OutALUOp;
    output reg [1:0] OutHalf;
    output reg [31:0] OutReadData1, OutReadData2, OutImmExtended, OutZeroExtension;
    output reg [4:0] OutRt, OutRd;
    output reg [31:0] OutPCAddResult;
    output reg [25:0] OutInstruction25To0;
    output reg OutJump;

    initial begin
        OutALUSrc <= 0;
        OutRegDst <= 0;
        OutRegWrite <= 0;
        OutMemRead <= 0;
        OutMemWrite <= 0;
        OutMemToReg <= 0;
        OutBranch <= 0;
        OutShift <= 0;
        OutALUOp <= 0;
        OutHalf <= 0;
        OutReadData1 <= 0;
        OutReadData2 <= 0;
        OutImmExtended <= 0;
        OutZeroExtension <= 0;
        OutRt <= 0;
        OutRd <= 0;
        OutPCAddResult <= 0;
        OutInstruction25To0 <= 0;
        OutJump <= 0;
    end

    always @(posedge Clk) begin
        OutALUSrc <= InALUSrc;
        OutRegDst <= InRegDst;
        OutRegWrite <= InRegWrite;
        OutMemRead <= InMemRead;
        OutMemWrite <= InMemWrite;
        OutMemToReg <= InMemToReg;
        OutBranch <= InBranch;
        OutShift <= InShift;
        OutALUOp <= InALUOp;
        OutHalf <= InHalf;
        OutReadData1 <= InReadData1;
        OutReadData2 <= InReadData2;
        OutImmExtended <= InImmExtended;
        OutZeroExtension <= InZeroExtension;
        OutRt <= InRt;
        OutRd <= InRd;
        OutPCAddResult <= InPCAddResult;
        OutInstruction25To0 <= InInstruction25To0;  
        OutJump <= InJump;      
    end
endmodule
