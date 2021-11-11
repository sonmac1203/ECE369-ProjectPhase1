`timescale 1ns / 1ps

module HazardDetection (PCWrite, IF_ID.Write, ControlMux, 
                        ID_EX.MemRead, ID_EX.RegWrite, ID_EX.MemWrite, ID_EX.Shift, EX_MEM.MemRead, EX_MEM.RegWrite, EX_MEM.MemWrite, EX_MEM.Shift, 
                        IF_ID.Rt, IF_ID.Rs, ID_EX.Rt, ID_EX.Rd, /*EX_MEM.Rt,*/ EX_MEM.Rd); // at MEM stage, Rt and Rd joins, so we only need Rd to represent both
    input ID_EX.MemRead, ID_EX.RegWrite, ID_EX.MemWrite, EX_MEM.MemRead, EX_MEM.RegWrite, EX_MEM.MemWrite;
    input [4:0] IF_ID.Rt, IF_ID.Rs;
    input [4:0] ID_EX.Rt, ID_EX.Rd;
    input [4:0] /*EX_MEM.Rt,*/ EX_MEM.Rd;

    output reg PCWrite, IF_ID.Write, ControlMux;

    initial begin
        PCWrite <= 1;
        IF_ID.Write <= 1;
        ControlMux <= 1;
    end

    always @(*) begin

        PCWrite <= 1;
        IF_ID.Write <= 1;
        ControlMux <= 1;

        // lw or any I-type followed by R-type - stall 1
        if ((ID_EX.MemRead == 1 || ID_EX.RegWrite == 1 || ID_EX.MemWrite == 1 || ID_EX.Shift == 1) && ((ID_EX.Rt == IF_ID.Rt) || (ID_EX.Rt == IF_ID.Rs))) begin
            PCWrite <= 0;
            IF_ID.Write < =0;
            ControlMux <= 0;
        end

        // lw or any I-type followed by R-type - stall 2
        if ((EX_MEM.MemRead == 1 || EX_MEM.RegWrite == 1 || EX_MEM.MemWrite == 1 || EX_MEM.Shift == 1) && ((EX_MEM.Rd == IF_ID.Rt) || (EX_MEM.Rd == IF_ID.Rs))) begin
            PCWrite <= 0;
            IF_ID.Write < =0;
            ControlMux <= 0;
        end 

        // R-type followed by R-type or followed by sw - stall 1
        if ((ID_EX.RegWrite == 1 || ID_EX.MemWrite == 1 || ID_EX.Shift == 1) && (ID_EX.Rd == IF_ID.Rt || ID_EX.Rd == IF_ID.Rs)) begin
            PCWrite <= 0;
            IF_ID.Write < =0;
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