`timescale 1ns / 1ps

module ControllerRegister(ControlMux, branch,
                          InALUSrc, OutALUSrc, 
                          InRegDst, OutRegDst, 
                          InRegWrite, OutRegWrite, 
                          InALUOp, OutALUOp, 
                          InMemRead, OutMemRead, 
                          InMemWrite, OutMemWrite, 
                          InMemToReg, OutMemToReg, 
                          Inbranch, Outbranch, 
                          Inhalf, Outhalf, 
                          Inshift, Outshift, 
                          InjrSrc, OutjrSrc, 
                          InjSrc, OutjSrc);
    input ControlMux, branch;
    input InALUSrc, InRegDst, InRegWrite, InMemRead, InMemWrite, InMemToReg, Inbranch, Inshift, InjrSrc, InjSrc;
    input [5:0] InALUOp;
    input [1:0] Inhalf;

    output reg OutALUSrc, OutRegDst, OutRegWrite, OutMemRead, OutMemWrite, OutMemToReg, Outbranch, Outshift, OutjrSrc, OutjSrc;
    output reg [5:0] OutALUOp;
    output reg [1:0] Outhalf;

    initial begin
        OutALUSrc <= 0;
        OutRegDst <= 0;
        OutRegWrite <= 0;
        OutALUOp <= 0;
        OutMemRead <= 0;
        OutMemWrite <= 0;
        OutMemToReg <= 0;
        Outbranch <= 0;
        Outhalf <= 0;
        Outshift <= 0;
        OutjrSrc <= 0;
        OutjSrc <= 0;
    end

    always @(*) begin
        if (ControlMux == 0 || branch == 1) begin
            OutALUSrc <= 0;
            OutRegDst <= 0;
            OutRegWrite <= 0;
            OutALUOp <= 0;
            OutMemRead <= 0;
            OutMemWrite <= 0;
            OutMemToReg <= 0;
            Outbranch <= 0;
            Outhalf <= 0;
            Outshift <= 0;
            OutjrSrc <= 0;
            OutjSrc <= 0;
        end
        else begin
            OutALUSrc <= InALUSrc;
            OutRegDst <= InRegDst;
            OutRegWrite <= InRegWrite;
            OutALUOp <= InALUOp;
            OutMemRead <= InMemRead;
            OutMemWrite <= InMemWrite;
            OutMemToReg <= InMemToReg;
            Outbranch <= Inbranch;
            Outhalf <= Inhalf;
            Outshift <= Inshift;
            OutjrSrc <= InjrSrc;
            OutjSrc <= InjSrc;
        end
    end
endmodule