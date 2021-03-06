`timescale 1ns / 1ps

module HazardDetectionUnit(PCWrite, IF_ID_Write, ControlMux,
                       IF_ID_MemWrite, 
                       ID_EX_MemRead, ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_Shift, ID_EX_Jump, EX_MEM_MemRead, EX_MEM_RegWrite, EX_MEM_MemWrite, EX_MEM_Shift, EX_MEM_Jump, 
                       IF_ID_Rt, IF_ID_Rs, IF_ID_Rd,/*ID_EX_Rt,*/ ID_EX_Rd, /*EX_MEM.Rt,*/ EX_MEM_Rd); // at MEM stage, Rt and Rd joins, so we only need Rd to represent both
    input ID_EX_MemRead, ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_Shift, EX_MEM_MemRead, EX_MEM_RegWrite, EX_MEM_MemWrite, EX_MEM_Shift;
    input [4:0] IF_ID_Rt, IF_ID_Rs, IF_ID_Rd;
    input IF_ID_MemWrite;
    input [4:0] /*ID_EX_Rt,*/ ID_EX_Rd;
    input [4:0] /*EX_MEM.Rt,*/ EX_MEM_Rd;
    input ID_EX_Jump, EX_MEM_Jump;

    output reg PCWrite, IF_ID_Write, ControlMux;
    
    // Combine rt and rd for both
    // not always reading from rt
    // ------------- RESOLVED
    
    // need hazard detection for JR
    

    initial begin
        PCWrite <= 1;
        IF_ID_Write <= 1;
        ControlMux <= 1;
    end

    always @(*) begin

        PCWrite <= 1;
        IF_ID_Write <= 1;
        ControlMux <= 1;

        // lw or any I-type followed by R-type - stall 1
//        if ((ID_EX_MemRead == 1 || ID_EX_RegWrite == 1 || ID_EX_MemWrite == 1 || ID_EX_Shift == 1) && ( ID_EX_Rt == IF_ID_Rt || ID_EX_Rt == IF_ID_Rs)) begin
//            PCWrite <= 0;
//            IF_ID_Write <= 0;
//            ControlMux <= 0;
//        end

        // lw or any I-type followed by R-type - stall 2
        if ((EX_MEM_MemRead == 1 || EX_MEM_RegWrite == 1 || EX_MEM_MemWrite == 1 || EX_MEM_Shift == 1) && (EX_MEM_Jump != 1) && (IF_ID_Rd != 0) && ((EX_MEM_Rd == IF_ID_Rt) || (EX_MEM_Rd == IF_ID_Rs))) begin
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlMux <= 0;
        end 
        else if ((EX_MEM_MemRead == 1 || EX_MEM_RegWrite == 1 || EX_MEM_MemWrite == 1 || EX_MEM_Shift == 1) && (EX_MEM_Jump != 1) && (EX_MEM_Rd == IF_ID_Rs)) begin
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlMux <= 0; 
        end 
        else if ((EX_MEM_MemRead == 1 || EX_MEM_RegWrite == 1 || EX_MEM_MemWrite == 1 || EX_MEM_Shift == 1) && (EX_MEM_Jump != 1) && (IF_ID_MemWrite == 1) && ((EX_MEM_Rd == IF_ID_Rt) || (EX_MEM_Rd == IF_ID_Rs))) begin
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlMux <= 0;
        end            

        // R-type followed by R-type or followed by sw - stall 1
        if ((ID_EX_MemRead == 1 || ID_EX_RegWrite == 1 || ID_EX_MemWrite == 1 || ID_EX_Shift == 1) && (ID_EX_Jump != 1) && (IF_ID_Rd != 0) && (ID_EX_Rd == IF_ID_Rt || ID_EX_Rd == IF_ID_Rs)) begin
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlMux <= 0;            
        end
        else if ((ID_EX_MemRead == 1 || ID_EX_RegWrite == 1 || ID_EX_MemWrite == 1 || ID_EX_Shift == 1) && (ID_EX_Jump != 1) && (ID_EX_Rd == IF_ID_Rs)) begin
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlMux <= 0;
        end
        else if ((ID_EX_MemRead == 1 || ID_EX_RegWrite == 1 || ID_EX_MemWrite == 1 || ID_EX_Shift == 1) && (ID_EX_Jump != 1) && (IF_ID_MemWrite == 1) && (ID_EX_Rd == IF_ID_Rt || ID_EX_Rd == IF_ID_Rs)) begin             
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlMux <= 0;
        end
        // // R-type followed by R-type or followed by sw - stall 2
        // if ((EX_MEM.RegWrite == 1 || EX_MEM.MemWrite == 1 || EX_MEM.Shift == 1) && (EX_MEM.Rd == IF_ID.Rt || EX_MEM.Rd == IF_ID.Rs)) begin
        //     PCWrite <= 0;
        //     IF_ID.Write < =0;
        //     ControlMux <= 0;            
        // end




    end
    
endmodule
