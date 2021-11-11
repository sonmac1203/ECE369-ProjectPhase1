`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - MEM_WB_Register.v
// Description - Create a Verilog file for the MEM/WB Register of the pipelined version
///////////////////////////////////////////////////////////////////////////////////////

module MEM_WB_Register(Clk,
                       InRegWrite, OutRegWrite, InMemToReg, OutMemToReg,
                       InReadDataMem, OutReadDataMem,
                       InALUResult, OutALUResult,
                       InRegDstMux, OutRegDstMux);
    input Clk, InRegWrite, InMemToReg;
    input [31:0] InALUResult, InReadDataMem;
    input [4:0] InRegDstMux;

    output reg  OutRegWrite, OutMemToReg;
    output reg [31:0] OutALUResult, OutReadDataMem;
    output reg [4:0] OutRegDstMux;

    initial begin
        OutRegWrite <= 0;
        OutMemToReg <= 0;
        OutALUResult <= 0;
        OutReadDataMem <= 0;
        OutRegDstMux <= 0;
    end

    always @(posedge Clk) begin
        OutRegWrite <= InRegWrite;
        OutMemToReg <= InMemToReg;
        OutALUResult <= InALUResult;
        OutReadDataMem <= InReadDataMem;
        OutRegDstMux <= InRegDstMux; 
    end
endmodule