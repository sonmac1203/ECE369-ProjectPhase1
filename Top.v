`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Group 29
// Members:             Son Mac | Ali Alaqeel | Efrain Torres
// Percentage Effort:   50%       35%           15%
//////////////////////////////////////////////////////////////
module Top(Clk, Rst, WriteData, PCValue, HiOUT, LoOUT, AddResultToIFID);
   
   
    input Clk, Rst;

    output [31:0] WriteData, HiOUT, LoOUT, PCValue, AddResultToIFID;
    wire [31:0] WriteDataWire, HiOUTWire, LoOUTWire, PCValueWire;

    wire [31:0] InProgramCounter;

    // Going into and going out of IF/ID register
    wire [31:0] OutInstructionMemory; // Instruction
    wire [31:0] AddResultToIFIDWire; // Addder to IF/ID
    wire [31:0] InstructionFromIFID; // Instruction output from IF/ID
    wire [31:0] IFIDToIDEX; // Adder from IF/ID to ID/EX

    // Going into and going out of Hazard Detection
    wire PCWrite, IF_ID_Write, ControlMux; // Going out

    // Going into and going out of Registers
    wire [4:0] WriteRegisterToRegisters; // WriteRegister going into Registers
    wire RegWriteToRegisters; // RegWrite going into Registers
    wire [31:0] ReadData1FromRegisters, ReadData2FromRegisters; // Read data going out of Registers

    // Going into and going out of Branch_Jump_Unit
    wire ZeroFromBranchJump;

    // Going out of Sign-extend
    wire [31:0] OutSignExtension;
    
    // Going out of Sign-extend-26
    wire[31:0] OutSignExtension26;
    
    // Going out of Zero-extend
    wire [31:0] OutZeroExtension;

    // Going out of Controller
    wire ALUSrcFromController, RegDstFromController, RegWriteFromController, MemReadFromController, MemWriteFromController, MemToRegFromController;
    wire branchFromController, shiftFromController, jrSrcFromController, jSrcFromController;
    wire [5:0] ALUOpFromController;
    wire [1:0] halfFromController;

    // Going out of Controller Register
    wire ALUSrcFromControllerReg, RegDstFromControllerReg, RegWriteFromControllerReg, MemReadFromControllerReg, MemWriteFromControllerReg, MemToRegFromControllerReg;
    wire branchFromControllerReg, shiftFromControllerReg, jrSrcFromControllerReg, jSrcFromControllerReg;
    wire [5:0] ALUOpFromControllerReg;
    wire [1:0] halfFromControllerReg;

    // Going into and out of ID/EX Register
    wire [31:0] AddResultFromIDEX;
    wire [31:0] ReadData1FromIDEX, ReadData2FromIDEX, OutSignExtensionFromIDEX, OutZeroExtensionFromIDEX;
    wire [4:0] RtFromIDEX, RdFromIDEX;
    wire ALUSrcFromIDEX, RegDstFromIDEX, RegWriteFromIDEX, MemReadFromIDEX, MemWriteFromIDEX, MemToRegFromIDEX, branchFromIDEX, shiftFromIDEX;
    wire jrSrcFromIDEX, jSrcFromIDEX;
    wire [5:0] ALUOpFromIDEX;
    wire [1:0] halfFromIDEX;
    wire [4:0] Instruction10To6FromIDEX;
    wire [25:0] Instruction25To0FromIDEX;
    assign jrSrcFromIDEX = 0;
    
    //assign mux1Test = AddResultToIFID;

    // Going out of ShiftLeft2_26Bit
    wire [27:0] Instruction25To0Shifted2;

    // Going out of ShiftLeft2_32Bit
    wire [31:0] ImmShiftedLeft;

    // Going out of the adder (added with imm shifted left)
    wire [31:0] AddResultAddedWithImmFromAdder;

    // Going out of shift mux
    wire [31:0] ReadDataFromShiftMux;

    // Going out of Rt or Imm mux
    wire [31:0] OutMuxReadData2OrImm;

    // Going out of Rt or Rd mux
    wire [4:0] OutMuxRtOrRd;

    // Going into and out of HiLoReg
    wire [31:0] LoIN, HiIN;

    // Going out of ALU32
    wire ZeroFromALU;
    wire [31:0] ALUResultToEXMEM;

    // Going out of EXMEM
    wire RegWriteFromEXMEM, MemReadFromEXMEM, MemWriteFromEXMEM, MemToRegFromEXMEM, branchFromEXMEM, ZeroFromEXMEM, jSrcFromEXMEM;
    wire shiftFromEXMEM; // Added for hazard detection
    wire [1:0] halfFromEXMEM;
    wire [31:0] ALUResultFromEXMEM, JumpDestFromEXMEM, ReadData2FromEXMEM, JDestFromEXMEM;
    wire [4:0] WriteRegisterFromEXMEM;
    assign jSrcFromEXMEM = 0;


    // Going out of AND gate
    wire PCSrc;
    assign PCSrc = 0;

    // Going out of Data Memory
    wire [31:0] ReadDataFromDM;

    // Going out of MEMWB
    wire MemToRegFromMEMWB;
    wire [31:0] ReadDataFromMEMWB, ALUResultFromMEMWB;

    // Going out muxImmOrNormalToPC
    wire [31:0] OutMuxImmOrNormalToPC;

    // Going out muxJorJr
    wire [31:0] OutMuxJorJr;
    
    Mux32Bit2To1 muxImmOrNormalToPC(
        .out(OutMuxImmOrNormalToPC),
        //.out(InProgramCounter),
        .inA(AddResultToIFID),
        .inB(JumpDestFromEXMEM),
        .sel(PCSrc)
        //.sel(0)
    );
    
    Mux32Bit2To1 muxJumpOrNotJump(
        .out(InProgramCounter),
        .inA(OutMuxImmOrNormalToPC),
        .inB(OutMuxJorJr),
        .sel(jrSrcFromIDEX)
    );

    Mux32Bit2To1 muxJorJr(
        .out(OutMuxJorJr),
        .inA(ReadData1FromIDEX),
        .inB(JDestFromEXMEM),
        .sel(jSrcFromEXMEM)
    );
    
    ProgramCounter PC(
        .Address(InProgramCounter),
        .PCResult(PCValueWire),
        .Reset(Rst),
        .Clk(Clk),
        .PCWrite(PCWrite) // Added for HazardDetection
    );
    
    assign PCValue = PCValueWire;
    InstructionMemory IM(
        .Address(PCValueWire),
        .Instruction(OutInstructionMemory)
    );

    PCAdder PCAdd(
        .PCResult(PCValueWire),
        .PCAddResult(AddResultToIFIDWire)
    );
    assign AddResultToIFID = AddResultToIFIDWire;

    IF_ID_Register IFID(
        .Clk(Clk),
        .InInstruction(OutInstructionMemory),
        .OutInstruction(InstructionFromIFID),
        .InPCAddResult(AddResultToIFIDWire),
        .OutPCAddResult(IFIDToIDEX),
        .IF_ID_Write(IF_ID_Write) // Added for HazardDetection
    );

    HazardDetectionUnit HazardDetection( // HazardDetection added
        .PCWrite(PCWrite), 
        .IF_ID_Write(IF_ID_Write), 
        .ControlMux(ControlMux), 
        .ID_EX_MemRead(MemReadFromIDEX), 
        .ID_EX_RegWrite(RegWriteFromIDEX), 
        .ID_EX_MemWrite(MemWriteFromIDEX), 
        .ID_EX_Shift(shiftFromIDEX), 
        .EX_MEM_MemRead(MemReadFromEXMEM), 
        .EX_MEM_RegWrite(RegWriteFromEXMEM), 
        .EX_MEM_MemWrite(MemWriteFromEXMEM), 
        .EX_MEM_Shift(shiftFromEXMEM), 
        .IF_ID_Rt(InstructionFromIFID[20:16]), 
        .IF_ID_Rs(InstructionFromIFID[25:21]), 
        /*.ID_EX_Rt(RtFromIDEX),*/ 
        .ID_EX_Rd(OutMuxRtOrRd), 
        /*.EX_MEM.Rt(),*/ 
        .EX_MEM_Rd(WriteRegisterFromEXMEM)
    );

    RegisterFile Registers(
        .ReadRegister1(InstructionFromIFID[25:21]), // Rs
        .ReadRegister2(InstructionFromIFID[20:16]), // Rt
        .WriteRegister(WriteRegisterToRegisters),
        .WriteData(WriteDataWire),
        .RegWrite(RegWriteToRegisters),
        .Clk(Clk),
        .ReadData1(ReadData1FromRegisters), // R[Rs]
        .ReadData2(ReadData2FromRegisters) // R[Rt]
    );

    Branch_Jump Brach_Jump_Unit(
        .Control(ALUOpFromController), 
        .A(ReadData1FromRegisters), // R[Rs]
        .B(ReadData2FromRegisters), // R[Rt]
        .Zero(ZeroFromBranchJump)
    );

    ANDGate andGate(
        .A(branchFromController),
        .B(ZeroFromBranchJump),
        .out(PCSrc)
    );

    SignExtension SignExt(
        .in(InstructionFromIFID[15:0]),
        .out(OutSignExtension)
    );

    ZeroExtension ZeroExt(
        .in(InstructionFromIFID[10:6]),
        .out(OutZeroExtension)
    );
    
    Controller Control(
        .Instruction(InstructionFromIFID), 
        .ALUSrc(ALUSrcFromController), 
        .RegDst(RegDstFromController), 
        .RegWrite(RegWriteFromController), 
        .ALUOp(ALUOpFromController), 
        .MemRead(MemReadFromController), 
        .MemWrite(MemWriteFromController), 
        .MemToReg(MemToRegFromController), 
        .branch(branchFromController), 
        .half(halfFromController),
        .shift(shiftFromController),
        .jrSrc(jrSrcFromController),
        .jSrc(jSrcFromController)
        //.PCSrc(PCSrc)
    );

    ControllerRegister ControllerReg(
        .ControlMux(ControlMux), 
        .branch(PCSrc),
        .InALUSrc(ALUSrcFromController), .OutALUSrc(ALUSrcFromControllerReg), 
        .InRegDst(RegDstFromController), .OutRegDst(RegDstFromControllerReg), 
        .InRegWrite(RegWriteFromController), .OutRegWrite(RegWriteFromControllerReg), 
        .InALUOp(ALUOpFromController), .OutALUOp(ALUOpFromControllerReg), 
        .InMemRead(MemReadFromController), .OutMemRead(MemReadFromControllerReg), 
        .InMemWrite(MemWriteFromController), .OutMemWrite(MemWriteFromControllerReg), 
        .InMemToReg(MemToRegFromController), .OutMemToReg(MemToRegFromControllerReg), 
        .Inbranch(branchFromController), .Outbranch(branchFromControllerReg), 
        .Inhalf(halfFromController), .Outhalf(halfFromControllerReg), 
        .Inshift(shiftFromController), .Outshift(shiftFromControllerReg), 
        .InjrSrc(jrSrcFromController), .OutjrSrc(jrSrcFromControllerReg), 
        .InjSrc(jSrcFromController), .OutjSrc(jSrcFromControllerReg)
    );
    
//    SignExtension_26Bit SignExt26(
//        .in(InstructionFromIFID[25:0]),
//        .out(OutSignExtension26)
//    );

    ID_EX_Register IDEX(
        .Clk(Clk), 
        .InReadData1(ReadData1FromRegisters), 
        .InReadData2(ReadData2FromRegisters), 
        .InImmExtended(OutSignExtension), 
        .InRt(InstructionFromIFID[20:16]), 
        .InRd(InstructionFromIFID[15:11]),
        .InALUSrc(ALUSrcFromControllerReg), 
        .InRegDst(RegDstFromControllerReg), 
        .InRegWrite(RegWriteFromControllerReg),
        .InALUOp(ALUOpFromControllerReg),
        .InMemRead(MemReadFromController), 
        .InMemWrite(MemWriteFromControllerReg), 
        .InMemToReg(MemToRegFromControllerReg), 
        .InBranch(branchFromControllerReg), 
        .InHalf(halfFromControllerReg), 
        .InShift(shiftFromControllerReg),
        .InJrSrc(jrSrcFromControllerReg),
        .InJSrc(jSrcFromControllerReg),
        .InPCAddResult(IFIDToIDEX), 
        .OutPCAddResult(AddResultFromIDEX),
        //.InInstruction25To0(OutSignExtension26),
        .InInstruction25To0(InstructionFromIFID[25:0]), 
        .OutInstruction25To0(Instruction25To0FromIDEX),
        .InZeroExtension(OutZeroExtension), 
        .OutZeroExtension(OutZeroExtensionFromIDEX),
        .OutReadData1(ReadData1FromIDEX),
        .OutReadData2(ReadData2FromIDEX), 
        .OutImmExtended(OutSignExtensionFromIDEX), 
        .OutRt(RtFromIDEX), 
        .OutRd(RdFromIDEX),
        .OutALUSrc(ALUSrcFromIDEX), 
        .OutRegDst(RegDstFromIDEX), 
        .OutRegWrite(RegWriteFromIDEX), 
        .OutALUOp(ALUOpFromIDEX), 
        .OutMemRead(MemReadFromIDEX), 
        .OutMemWrite(MemWriteFromIDEX), 
        .OutMemToReg(MemToRegFromIDEX), 
        .OutBranch(branchFromIDEX), 
        .OutHalf(halfFromIDEX), 
        .OutShift(shiftFromIDEX),
        .OutJrSrc(jrSrcFromIDEX), 
        .OutJSrc(jSrcFromIDEX)
    );

    ShiftLeft2_26Bit shiftleft2_26(
        .in(Instruction25To0FromIDEX),
        .out(Instruction25To0Shifted2)
    );

    ShiftLeft2_32Bit shiftleft2_32_Imm(
        .in(OutSignExtensionFromIDEX),
        .out(ImmShiftedLeft)
    );

    Adder adder(
        .A(AddResultFromIDEX),
        .B(ImmShiftedLeft),
        .out(AddResultAddedWithImmFromAdder)
    );

    Mux32Bit2To1 muxShift(
        .out(ReadDataFromShiftMux), 
        .inA(ReadData1FromIDEX), 
        .inB(OutZeroExtensionFromIDEX), 
        .sel(shiftFromIDEX)
    );

    Mux32Bit2To1 muxReadData2OrImm(
        .out(OutMuxReadData2OrImm),
        .inA(ReadData2FromIDEX),
        .inB(OutSignExtensionFromIDEX),
        .sel(ALUSrcFromIDEX)
    );

    Mux5Bit2To1 muxRtOrRd(
        .out(OutMuxRtOrRd),
        .inA(RtFromIDEX),
        .inB(RdFromIDEX),
        .sel(RegDstFromIDEX)
    );

    Hi_Lo_Register HiLoReg(
        .Clk(Clk), 
        .LoIN(LoOUTWire), 
        .HiIN(HiOUTWire), 
        .LoOUT(LoIN), 
        .HiOUT(HiIN)
    );

    ALU32Bit ALU(
        .ALUControl(ALUOpFromIDEX), 
        .A(ReadDataFromShiftMux), 
        .B(OutMuxReadData2OrImm), 
        .ALUResult(ALUResultToEXMEM), 
        .Zero(ZeroFromALU), 
        .LoIN(LoIN), 
        .HiIN(HiIN), 
        .LoOUT(LoOUTWire), 
        .HiOUT(HiOUTWire)
    );

    EX_MEM_Register EXMEM(
        .Clk(Clk), 
        .InRegWrite(RegWriteFromIDEX), 
        .OutRegWrite(RegWriteFromEXMEM), 
        .InBranch(branchFromIDEX), 
        .OutBranch(branchFromEXMEM), 
        .InMemWrite(MemWriteFromIDEX), 
        .OutMemWrite(MemWriteFromEXMEM), 
        .InMemRead(MemReadFromIDEX), 
        .OutMemRead(MemReadFromEXMEM), // control
        .InMemToReg(MemToRegFromIDEX), 
        .OutMemToReg(MemToRegFromEXMEM), 
        .InHalf(halfFromIDEX), 
        .OutHalf(halfFromEXMEM), // signals
        .InJSrc(jSrcFromIDEX),
        .OutJSrc(jSrcFromEXMEM),
        .InJumpDest(AddResultAddedWithImmFromAdder), 
        .OutJumpDest(JumpDestFromEXMEM), // PC + 4*Imm
        .InJDest({Instruction25To0Shifted2, AddResultFromIDEX[31:28]}), 
        .OutJDest(JDestFromEXMEM),
        .InZero(ZeroFromALU), 
        .OutZero(ZeroFromEXMEM), 
        .InALUResult(ALUResultToEXMEM), 
        .OutALUResult(ALUResultFromEXMEM), // ALU outputs
        .InReadData2(ReadData2FromIDEX), 
        .OutReadData2(ReadData2FromEXMEM),
        .InRegDstMux(OutMuxRtOrRd), 
        .OutRegDstMux(WriteRegisterFromEXMEM),
        .InShift(shiftFromIDEX), // Added for hazard detection
        .OutShift(shiftFromEXMEM) // Added for hazard detection
    );

    // ANDGate andGate(
    //     .A(branchFromEXMEM),
    //     .B(ZeroFromEXMEM),
    //     .out(PCSrc)
    // );

    DataMemory DM(
        .Address(ALUResultFromEXMEM), 
        .WriteData(ReadData2FromEXMEM), 
        .Clk(Clk), 
        .MemWrite(MemWriteFromEXMEM), 
        .MemRead(MemReadFromEXMEM), 
        .ReadData(ReadDataFromDM), 
        .half(halfFromEXMEM)
    );

    MEM_WB_Register MEMWB(
        .Clk(Clk),
        .InRegWrite(RegWriteFromEXMEM), 
        .OutRegWrite(RegWriteToRegisters), 
        .InMemToReg(MemToRegFromEXMEM), 
        .OutMemToReg(MemToRegFromMEMWB),
        .InReadDataMem(ReadDataFromDM), 
        .OutReadDataMem(ReadDataFromMEMWB),
        .InALUResult(ALUResultFromEXMEM), 
        .OutALUResult(ALUResultFromMEMWB),
        .InRegDstMux(WriteRegisterFromEXMEM), 
        .OutRegDstMux(WriteRegisterToRegisters)
    );

    Mux32Bit2To1 muxWriteDataReg(
        .out(WriteDataWire),
        .inA(ReadDataFromMEMWB),
        .inB(ALUResultFromMEMWB),
        .sel(MemToRegFromMEMWB)
    );

    assign HiOUT = HiOUTWire;
    assign LoOUT = LoOUTWire;
    assign WriteData = WriteDataWire;
endmodule











    




    







    