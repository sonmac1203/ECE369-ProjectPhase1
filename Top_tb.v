`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Group 29
// Members:             Son Mac | Ali Alaqeel | Efrain Torres
// Percentage Effort:   50%       35%           15%
//////////////////////////////////////////////////////////////
module Top_tb();
    reg Clk, Rst;
    wire [31:0] WriteData, HiOUT, LoOUT, PCValue, AddResultToIFID;

    Top test(
        .Clk(Clk), 
        .Rst(Rst), 
        .WriteData(WriteData), 
        .PCValue(PCValue), 
        .HiOUT(HiOUT), 
        .LoOUT(LoOUT),
        .AddResultToIFID(AddResultToIFID)
    );

    initial begin
        Clk <= 1'b1;
        Rst <= 1;
        #100;

        Rst <= 0;
        Clk <= 1'b0;
        forever #100 Clk <= ~Clk;
    end
endmodule

