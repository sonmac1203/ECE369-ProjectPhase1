`timescale 1ns / 1ps

module Branch_Jump(Control, A, B, Zero);

    input [5:0] Control;
    input [31:0] A, B;
    output reg Zero;

    initial begin
        Zero <= 0;
    end

    always @(*) begin
        Zero <= 0;
        case (Control)

            6'b000111: begin// bgez
				if ($signed(A) >= 0)
					Zero <= 1;
            end

            6'b001000: begin // beq
				if ($signed(A) == $signed(B))
					Zero <= 1;      
            end

            6'b001001: begin // bne
				if ($signed(A) != $signed(B))
					Zero <= 1;                
            end

            6'b001010: begin // bgtz
				if ($signed(A) > 0)
					Zero <= 1;                
            end

            6'b001011: begin // blez
				if ($signed(A) <= 0)
					Zero <= 1;
            end

			6'b001100: begin // bltz
				if ($signed(A) < 0)
					Zero <= 1;
			end

			6'b001101: begin //j
				Zero <= 1;
			end

			6'b001110: begin // jal
				Zero <= 1;
			end

			6'b100011: begin // jr
				Zero <= 1;
			end
        endcase
    end
endmodule