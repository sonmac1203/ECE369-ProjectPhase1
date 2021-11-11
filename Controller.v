`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - Controller.v
// Description - Present the control signals for the datapath so that it supports all the required instructions
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Controller(Instruction, ALUSrc, RegDst, RegWrite, ALUOp, MemRead, MemWrite, MemToReg, branch, half, shift, jrSrc, jSrc /*PCSrc*/);
    input [31:0] Instruction;
    output reg ALUSrc, RegDst, RegWrite, MemRead, MemWrite, MemToReg, branch, shift, jrSrc, jSrc;
    output reg [5:0] ALUOp;
    output reg [1:0] half;

    initial begin
        ALUSrc <= 0;
        RegDst <= 0;
        RegWrite <= 0;
        ALUOp <= 0;
        MemRead <= 0;
        MemWrite <= 0;
        MemToReg <= 0;
        branch <= 0;
        half <= 0;
        shift <= 0;
        jrSrc <= 0;
        jSrc <= 0;
        //PCSrc <= 0;
    end

    always @(Instruction) begin
        
        // NOP
        if (Instruction == 32'd0) begin
            ALUSrc <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            ALUOp <= 6'b000000;
            MemRead <= 0;
            MemWrite <= 0;
            MemToReg <= 0;
            branch <= 0;
            half <= 0;
            shift <= 0;
            jrSrc <= 0;
            jSrc <= 0;
            //PCSrc <= 0;
        end

        else begin
            case (Instruction[31:26])

                // R-type instructions
                6'b000000: begin
                    ALUSrc <= 0;
                    RegDst <= 1;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    case (Instruction[5:0])
                        6'b100000: begin // add
                            ALUOp <= 6'b000000;
                        end

                        6'b100001: begin // addu
                            ALUOp <= 6'b100000;
                        end

                        6'b100010: begin // sub
                            ALUOp <= 6'b000001;
                        end

                        6'b011000: begin // mult
                            RegWrite <= 0;
                            ALUOp <= 6'b000011;
                        end

                        6'b011001: begin // multu
                            RegWrite <= 0;
                            ALUOp <= 6'b100001;
                        end

                        6'b100100: begin // and
                            ALUOp <= 6'b001111;
                        end

                        6'b100101: begin // or
                            ALUOp <= 6'b010000;
                        end

                        6'b100111: begin // nor
                            ALUOp <= 6'b010001;

                        end

                        6'b100110: begin // xor
                            ALUOp <= 6'b010010;

                        end

                        6'b000000: begin // sll
                            shift <= 1;
                            ALUOp <= 6'b010100;
                        end

                        6'b000010: begin // srl and rotr
                            if (Instruction[21] == 0) begin // srl 
                                shift <= 1;
                                ALUOp <= 6'b010101;
                            end
                            else if (Instruction[21] == 1) begin // rotr
                                shift <= 1;
                                ALUOp <= 6'b011000;
                            end
                        end

                        6'b000100: begin // sllv
                            ALUOp <= 6'b010100;
                        end

                        6'b000110: begin // srlv and rotrv
                            if (Instruction[6] == 0) begin // srlv
                                ALUOp <= 6'b010101;
                            end
                            else if (Instruction[6] == 1) begin // rotrv
                                ALUOp <= 6'b011000;
                            end
                        end

                        6'b101010: begin // slt
                            ALUOp <= 6'b011011;
                        end

                        6'b001011: begin // movn
                            ALUOp <= 6'b010110;
                        end

                        6'b001010: begin // movz
                            ALUOp <= 6'b010111;
                        end

                        6'b000011: begin // sra
                            shift <= 1;
                            ALUOp <= 6'b011001;
                        end
                        6'b000111: begin // srav
                            ALUOp <= 6'b011001;
                        end
                        6'b101011: begin // sltu
                            ALUOp <= 6'b100010;
                        end

                        6'b010001: begin // mthi
                            RegWrite <= 0;
                            ALUOp <= 6'b011100;
                        end

                        6'b010011: begin // mtlo
                            RegWrite <= 0;
                            ALUOp <= 6'b011101;
                        end

                        6'b010000: begin // mfhi
                            ALUOp <= 6'b011110;
                        end

                        6'b010010: begin // mflo
                            ALUOp <= 6'b011111;
                        end

                        6'b001000: begin // jr
                            RegWrite <= 0;
                            ALUOp <= 6'b100011;
                            jrSrc <= 1;
                        end
                endcase
                end

                // I-type instructions
                6'b001000: begin // addi
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    shift <= 0;
                    half <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000000;
                end

                6'b001001: begin // addiu
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    shift <= 0;
                    half <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b100000;
                end

                6'b100011: begin // lw
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 1;
                    MemWrite <= 0;
                    MemToReg <= 0;
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000000;
                end

                6'b101011: begin // sw
                    ALUSrc <= 1;
                    RegDst <= 0; // X
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 1;
                    MemToReg <= 0; // X
                    branch <= 0;
                    half <= 0; // the whole thing
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000000;
                end

                6'b101000: begin // sb
                    ALUSrc <= 1;
                    RegDst <= 0; // X
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 1;
                    MemToReg <= 0; // X
                    branch <= 0;
                    half <= 6'b10; // byte
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000000;
                end

                6'b100001: begin // lh
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 1;
                    MemWrite <= 0;
                    MemToReg <= 0;
                    branch <= 0;
                    half <= 6'b01;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000000;
                end

                6'b100000: begin // lb
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 1;
                    MemWrite <= 0;
                    MemToReg <= 0;
                    branch <= 0;
                    half <= 6'b10;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000000;
                end

                6'b101001: begin // sh
                    ALUSrc <= 1;
                    RegDst <= 0; // X
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 1;
                    MemToReg <= 0; // X
                    branch <= 0;
                    half <= 6'b01; // byte
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000000;
                end


                6'b001111: begin // lui
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1; 
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b000110;
                end

                6'b000001: begin // bgez and bltz
                    ALUSrc <= 0; // X
                    RegDst <= 0; // X
                    RegWrite <= 0; 
                    MemRead <= 0; 
                    MemWrite <= 0; 
                    MemToReg <= 0; // X
                    branch <= 1;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    if (Instruction[20:16] == 5'b00001) begin // bgez
                        ALUOp <= 6'b000111;    
                    end
                    else if (Instruction[20:16] == 5'b00000) begin // bltz
                        ALUOp <= 6'b001100;
                    end
                end

                6'b000100: begin // beq
                    ALUSrc <= 0;
                    RegDst <= 0; // X
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 0; // X
                    branch <= 1;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    ALUOp <= 6'b001000;
                end

                6'b000101: begin // bne
                    ALUSrc <= 0;
                    RegDst <= 0; // X
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 0; // X
                    branch <= 1;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    ALUOp <= 6'b001001;
                end

                6'b000111: begin // bgtz
                    ALUSrc <= 0; // X
                    RegDst <= 0; // X
                    RegWrite <= 0; 
                    MemRead <= 0; 
                    MemWrite <= 0; 
                    MemToReg <= 0; // X
                    branch <= 1;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    ALUOp <= 6'b001010;
                end

                6'b000110: begin // blez
                    ALUSrc <= 0; // X
                    RegDst <= 0; // X
                    RegWrite <= 0; 
                    MemRead <= 0; 
                    MemWrite <= 0; 
                    MemToReg <= 0; // X
                    branch <= 1;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    ALUOp <= 6'b001011;
                end

                6'b001100: begin // andi
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b001111;
                end

                6'b001101: begin // ori
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b010000;
                end

                6'b001110: begin // xori
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b010010;
                end

                6'b001010: begin // slti
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b011011;
                end
                6'b001011: begin // sltiu
                    ALUSrc <= 1;
                    RegDst <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    branch <= 0;
                    half <= 0;
                    shift <= 0;
                    jrSrc <= 0;
                    jSrc <= 0;
                    //PCSrc <= 0;
                    ALUOp <= 6'b100010;
                end

                6'b011100: begin
                    if (Instruction[5:0] == 6'b000010) begin // mul
                        ALUSrc <= 0;
                        RegDst <= 1;
                        RegWrite <= 1;
                        MemRead <= 0;
                        MemWrite <= 0;
                        MemToReg <= 1;
                        branch <= 0;
                        half <= 0;
                        shift <= 0;
                        jrSrc <= 0;
                        jSrc <= 0;
                        //PCSrc <= 0;
                        ALUOp <= 6'b000010;
                    end

                    else if (Instruction[5:0] == 6'b000000) begin // madd
                        ALUSrc <= 0;
                        RegDst <= 1;
                        RegWrite <= 0;
                        MemRead <= 0;
                        MemWrite <= 0;
                        MemToReg <= 1;
                        branch <= 0; 
                        half <= 0; 
                        shift <= 0;
                        jrSrc <= 0;
                        jSrc <= 0;
                        //PCSrc <= 0;
                        ALUOp <= 6'b000100;
                    end

                    else if (Instruction[5:0] == 6'b000100) begin // msub
                        ALUSrc <= 0;
                        RegDst <= 1;
                        RegWrite <= 0;
                        MemRead <= 0;
                        MemWrite <= 0;
                        MemToReg <= 1;
                        shift <= 0;
                        branch <= 0;
                        half <= 0;
                        jrSrc <= 0;
                        jSrc <= 0;
                        //PCSrc <= 0;
                        ALUOp <= 6'b000101;  
                    end
                end

                6'b011111: begin // seh and seb
                    if (Instruction[10:6] == 5'b11000) begin // seh
                        ALUSrc <= 0;
                        RegDst <= 1;
                        RegWrite <= 1;
                        MemRead <= 0;
                        MemWrite <= 0;
                        MemToReg <= 1;
                        shift <= 0;
                        branch <= 0;
                        half <= 0;
                        jrSrc <= 0;
                        jSrc <= 0;
                        //PCSrc <= 0;
                        ALUOp <= 6'b010011;  
                    end
                    else if (Instruction[10:6] == 10000) begin // seb
                        ALUSrc <= 0;
                        RegDst <= 1;
                        RegWrite <= 1;
                        MemRead <= 0;
                        MemWrite <= 0;
                        MemToReg <= 1;
                        shift <= 0;
                        branch <= 0;
                        half <= 0;
                        jrSrc <= 0;
                        jSrc <= 0;
                        //PCSrc <= 0;
                        ALUOp <= 6'b011010; 
                    end
                end

                6'b000010: begin // j
                    ALUSrc <= 0;
                    RegDst <= 0;
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    shift <= 0;
                    branch <= 0;
                    half <= 0;
                    jrSrc <= 1;
                    jSrc <= 1;
                    //PCSrc <= 0;
                    ALUOp <= 6'b001101;
                end

                 6'b000011: begin // jal
                    ALUSrc <= 0;
                    RegDst <= 0;
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 0;
                    MemToReg <= 1;
                    shift <= 0;
                    branch <= 0;
                    half <= 0;
                    jrSrc <= 1;
                    jSrc <= 1;
                    //PCSrc <= 0;
                    ALUOp <= 6'b001101;
                 end
            endcase

        end
    end
endmodule