`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: N-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU, so that it supports all arithmetic operations 
// needed by the MIPS instructions given in Labs5-8.docx document. 
//   The 'ALUResult' will output the corresponding result of the operation 
//   based on the 32-Bit inputs, 'A', and 'B'. 
//   The 'Zero' flag is high when 'ALUResult' is '0'. 
//   The 'ALUControl' signal should determine the function of the ALU 
//   You need to determine the bitwidth of the ALUControl signal based on the number of 
//   operations needed to support. 
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit(ALUControl, A, B, ALUResult, Zero, LoIN, HiIN, LoOUT, HiOUT);

	input [5:0] ALUControl; // control bits for ALU operation
                                // you need to adjust the bitwidth as needed
	input [31:0] A, B;	    // inputs
	
	input [31:0] LoIN, HiIN;
	
	reg [63:0] temp;

	output reg [31:0] ALUResult;	// answer
	output reg Zero;	    // Zero=1 if ALUResult == 0

	output reg [31:0] LoOUT;
	output reg [31:0] HiOUT;

    /* Please fill in the implementation here... */
	always @(*) begin

		Zero <= 0;
		LoOUT <= LoIN;
		HiOUT <= HiIN;

		case (ALUControl)

			// Arithmetic
			// add
			6'b000000: begin
				ALUResult <= $signed(A) + $signed(B);
				if (ALUResult == 0)
					Zero <= 1;
			end

			// addu
			6'b100000: begin
				ALUResult <= A + B;
				if (ALUResult == 0)
					Zero <= 1;
			end

			// sub
			6'b000001: begin
				ALUResult <= A - B;
				if (ALUResult == 0)
					Zero <= 1;
			end

			// mul
			6'b000010: begin
				ALUResult <= A * B;
				if (ALUResult == 0)
					Zero <= 1;
			end

			// mult
			6'b000011: begin
				temp <= $signed(A) * $signed(B);
				HiOUT <= temp[63:32];
				LoOUT <= temp[31:0];
				if (temp == 0)
					Zero <= 1;
			end

			// multu
			6'b100001: begin
				temp <= A * B;
				HiOUT <= temp[63:32];
				LoOUT <= temp[31:0];
				if (temp == 0)
					Zero <= 1;			
			end

			// madd
			6'b000100: begin
				temp = $signed({HiIN, LoIN}) + $signed($signed(A) * $signed(B));
				//ALUResult <= $signed({HiIN, LoIN}) + $signed(($signed(A) * $signed(B));
				HiOUT <= temp[63:32];
				LoOUT <= temp[31:0];
				if (temp == 0) // if temp == 0
					Zero <= 1;					
			end

			// msub
			6'b000101: begin
				temp <= $signed({HiIN, LoIN}) - $signed($signed(A) * $signed(B));
				//ALUResult <= $signed({HiIN, LoIN}) - $signed(($signed(A) * $signed(B));
				HiOUT <= temp[63:32];
				LoOUT <= temp[31:0];
				if (temp == 0) // temp == 0 
					Zero <= 1;					
			end

			// and 
			6'b001111: begin
				ALUResult <= A & B;
				if (ALUResult == 0)
					Zero <= 1;
			end

			// or
			6'b010000: begin
				ALUResult <= A | B;
				if (ALUResult == 0)
					Zero <= 1;
			end

			// nor
			6'b010001: begin
				ALUResult <= ~(A | B);
				if (ALUResult == 0)
					Zero <= 1;
			end

			// xor
			6'b010010: begin
				ALUResult <= (A & ~B) | (~A & B);
				if (ALUResult == 0)
					Zero <= 1;
			end

			// seh
			6'b010011: begin
				if (B[15] == 1) begin
					ALUResult <= {16'b1111111111111111, B[15:0]};
				end
				else begin
					ALUResult <= {16'b0, B[15:0]};
				end
				if (ALUResult == 0)
					Zero <= 1;
			end

			// sll
			6'b010100: begin
				ALUResult <= B << A[4:0];
				if (ALUResult == 0)
					Zero <= 1; 
			end

			// srl
			6'b010101: begin
				ALUResult <= B >> A[4:0];
				if (ALUResult == 0)
					Zero <= 1;
			end

			// movn
			6'b010110: begin
				if (B != 0) begin
					ALUResult <= A;
				end
				if (ALUResult == 0)
					Zero <= 1;
			end

			// movz
			6'b010111: begin
				if (B == 0) begin
					ALUResult <= A;
				end
				if (ALUResult == 0)
					Zero <= 1;
			end

			// rotr
			6'b011000: begin
				//ALUResult <= ((A >> B) | (A << (32 - B)));
				ALUResult <= ((B >> A[4:0]) | (B << (32 - A[4:0])));
				if (ALUResult == 0)
					Zero <= 1; 
			end

			// sra
			6'b011001: begin
				ALUResult <= B >>> A;
				if (ALUResult == 0)
					Zero <= 1;
			end

			// seb
			6'b011010: begin
				if (B[7] == 1) begin
					ALUResult <= {24'b111111111111111111111111, B[7:0]};
				end
				else begin
					ALUResult <= {24'b0, B[7:0]};
				end
				if (ALUResult == 0)
					Zero <= 1;
			end

			// slt
			6'b011011: begin
				ALUResult <= ($signed(A) < $signed(B));
				if (ALUResult == 0)
					Zero <= 1;
			end

			// stlu
			6'b100010: begin
				ALUResult <= (A < B);
				if (ALUResult == 0)
					Zero <= 1;
			end

			// mthi
			6'b011100: begin
				HiOUT <= A;
			end

			// mtlo
			6'b011101: begin
				LoOUT <= A;
			end

			// mfhi
			6'b011110: begin
				ALUResult <= HiIN;
			end

			// mflo
			6'b011111: begin
				ALUResult <= LoIN;
			end

			// lui
			6'b000110: begin
	            ALUResult <= {B[15:0], 16'b0};
           		if (ALUResult == 0)
                	Zero <= 1;			
			end

			// bgez
			6'b000111: begin
				if ($signed(A) >= 0)
					Zero <= 1;
			end

			// beq
			6'b001000: begin
				if ($signed(A) == $signed(B))
					Zero <= 1;
			end

			// bne
			6'b001001: begin
				if ($signed(A) != $signed(B))
					Zero <= 1;
			end

			// bgtz
			6'b001010: begin
				if ($signed(A) > 0)
					Zero <= 1;
			end

			// blez
			6'b001011: begin
				if ($signed(A) <= 0)
					Zero <= 1;
			end

			// bltz
			6'b001100: begin
				if ($signed(A) < 0)
					Zero <= 1;
			end

			// j
			6'b001101: begin
				Zero <= 1;
			end

			// jal
			6'b001110: begin
				Zero <= 1;
			end

			// jr
			6'b100011: begin
				Zero <= 1;
			end
		endcase
	end

endmodule

