`timescale 1ns / 1ps

module Hi_Lo_Register(Clk, LoIN, HiIN, LoOUT, HiOUT);
    input Clk;
    input [31:0] LoIN, HiIN;

    output reg [31:0] LoOUT, HiOUT;

    initial begin
        LoOUT <= 0;
        HiOUT <= 0;
    end

    always @(posedge Clk) begin
        LoOUT <= LoIN;
        HiOUT <= HiIN;
    end
endmodule