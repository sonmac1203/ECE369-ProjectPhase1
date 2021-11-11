`timescale 1ns / 1ps

module ShiftLeft2_26Bit(in, out);
    input [25:0] in;
    output reg [27:0] out;

    initial begin
        out <= 28'b0;
    end

    always @(*) begin
        out <= in << 2;
    end

endmodule