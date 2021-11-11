`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - EX_Mem_Register.v
// Description - Create a Verilog file for the EX/MEM Register of the pipelined version
///////////////////////////////////////////////////////////////////////////////////////

module EX_MEM_Register(Clk, 
                       InRegWrite, OutRegWrite, InBranch, OutBranch, InMemWrite, OutMemWrite, InMemRead, OutMemRead, // control
                       InMemToReg, OutMemToReg, InHalf, OutHalf, InJSrc, OutJSrc, // signals
                       InJumpDest, OutJumpDest, // PC + 4*Imm
                       InJDest, OutJDest,
                       InZero, OutZero, InALUResult, OutALUResult, // ALU outputs
                       InReadData2, OutReadData2,
                       InRegDstMux, OutRegDstMux,
                       InShift, OutShift); // Added for hazard detection

    input Clk, InRegWrite, InBranch, InMemWrite, InMemRead, InMemToReg, InZero, InJSrc, InShift;
    input [1:0] InHalf;
    input [4:0] InRegDstMux;
    input [31:0] InReadData2, InALUResult, InJumpDest, InJDest;

    output reg OutRegWrite, OutBranch, OutMemWrite, OutMemRead, OutMemToReg, OutZero, OutJSrc, OutShift;
    output reg [1:0] OutHalf;
    output reg [4:0] OutRegDstMux;
    output reg [31:0] OutReadData2, OutALUResult, OutJumpDest, OutJDest;

    initial begin
        OutRegWrite <= 0;
        OutBranch <= 0;
        OutMemWrite <= 0;
        OutMemRead <= 0;
        OutMemToReg <= 0;
        OutZero <= 0;
        OutHalf <= 0;
        OutRegDstMux <= 0;
        OutReadData2 <= 0;
        OutALUResult <= 0;
        OutJumpDest <= 0;
        OutJDest <= 0;
        OutShift <= 0;
    end

    always @(posedge Clk) begin
        OutRegWrite <= InRegWrite;
        OutBranch <= InBranch;
        OutMemWrite <= InMemWrite;
        OutMemRead <= InMemRead;
        OutMemToReg <= InMemToReg;
        OutZero <= InZero;
        OutHalf <= InHalf;
        OutRegDstMux <= InRegDstMux;
        OutReadData2 <= InReadData2;
        OutALUResult <= InALUResult;
        OutJumpDest <= InJumpDest;
        OutJDest <= InJDest;
        OutShift <= InShift;
        
    end
endmodule
