`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - data_memory.v
// Description - 32-Bit wide data memory.
//
// INPUTS:-
// Address: 32-Bit address input port.
// WriteData: 32-Bit input port.
// Clk: 1-Bit Input clock signal.
// MemWrite: 1-Bit control signal for memory write.
// MemRead: 1-Bit control signal for memory read.
//
// OUTPUTS:-
// ReadData: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design the above memory similar to the 'RegisterFile' model in the previous 
// assignment.  Create a 1K memory, for which we need 10 bits.  In order to 
// implement byte addressing, we will use bits Address[11:2] to index the 
// memory location. The 'WriteData' value is written into the address 
// corresponding to Address[11:2] in the positive clock edge if 'MemWrite' 
// signal is 1. 'ReadData' is the value of memory location Address[11:2] if 
// 'MemRead' is 1, otherwise, it is 0x00000000. The reading of memory is not 
// clocked.
//
// you need to declare a 2d array. in this case we need an array of 1024 (1K)  
// 32-bit elements for the memory.   
// for example,  to declare an array of 256 32-bit elements, declaration is: reg[31:0] memory[0:255]
// if i continue with the same declaration, we need 8 bits to index to one of 256 elements. 
// however , address port for the data memory is 32 bits. from those 32 bits, least significant 2 
// bits help us index to one of the 4 bytes within a single word. therefore we only need bits [9-2] 
// of the "Address" input to index any of the 256 words. 
////////////////////////////////////////////////////////////////////////////////

module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData, half); 

    input [31:0] Address; 	// Input Address 
    input [31:0] WriteData; // Data that needs to be written into the address 
    input Clk;
    input MemWrite; 		// Control signal for memory write 
    input MemRead;
    input [1:0] half; 			// Control signal for memory read 

    output reg[31:0] ReadData; // Contents of memory location at Address

    reg [31:0] memory [0:1023];

    initial begin
        memory[0] <= 16;
        memory[1] <= 16;
        memory[2] <= 4;
        memory[3] <= 4;
        memory[4] <= 0;
        memory[5] <= 1;
        memory[6] <= 2;
        memory[7] <= 3;
        memory[8] <= 0;
        memory[9] <= 0;
        memory[10] <= 0;
        memory[11] <= 0;
        memory[12] <= 0;
        memory[13] <= 0;
        memory[14] <= 0;
        memory[15] <= 0;
        memory[16] <= 0;
        memory[17] <= 0;
        memory[18] <= 0;
        memory[19] <= 0;
        memory[20] <= 1;
        memory[21] <= 2;
        memory[22] <= 3;
        memory[23] <= 4;
        memory[24] <= 4;
        memory[25] <= 5;
        memory[26] <= 6;
        memory[27] <= 7;
        memory[28] <= 8;
        memory[29] <= 9;
        memory[30] <= 10;
        memory[31] <= 11;
        memory[32] <= 0;
        memory[33] <= 1;
        memory[34] <= 2;
        memory[35] <= 3;
        memory[36] <= 2;
        memory[37] <= 3;
        memory[38] <= 32;
        memory[39] <= 1;
        memory[40] <= 2;
        memory[41] <= 3;
        memory[42] <= 12;
        memory[43] <= 14;
        memory[44] <= 16;
        memory[45] <= 18;
        memory[46] <= 20;
        memory[47] <= 1;
        memory[48] <= 1;
        memory[49] <= 2;
        memory[50] <= 3;
        memory[51] <= 4;
        memory[52] <= 3;
        memory[53] <= 4;
        memory[54] <= 1;
        memory[55] <= 2;
        memory[56] <= 3;
        memory[57] <= 4;
        memory[58] <= 18;
        memory[59] <= 21;
        memory[60] <= 24;
        memory[61] <= 27;
        memory[62] <= 30;
        memory[63] <= 33;
        memory[64] <= 2;
        memory[65] <= 3;
        memory[66] <= 4;
        memory[67] <= 5;
        memory[68] <= 0;
        memory[69] <= 4;
        memory[70] <= 2;
        memory[71] <= 3;
        memory[72] <= 4;
        memory[73] <= 5;
        memory[74] <= 24;
        memory[75] <= 28;
        memory[76] <= 32;
        memory[77] <= 36;
        memory[78] <= 40;
        memory[79] <= 44;
        memory[80] <= 3;
        memory[81] <= 4;
        memory[82] <= 5;
        memory[83] <= 6;
        memory[84] <= 0;
        memory[85] <= 5;
        memory[86] <= 3;
        memory[87] <= 4;
        memory[88] <= 5;
        memory[89] <= 6;
        memory[90] <= 30;
        memory[91] <= 35;
        memory[92] <= 40;
        memory[93] <= 45;
        memory[94] <= 50;
        memory[95] <= 55;
        memory[96] <= 3;
        memory[97] <= 4;
        memory[98] <= 5;
        memory[99] <= 6;
        memory[100] <= 0;
        memory[101] <= 6;
        memory[102] <= 12;
        memory[103] <= 18;
        memory[104] <= 24;
        memory[105] <= 30;
        memory[106] <= 36;
        memory[107] <= 42;
        memory[108] <= 48;
        memory[109] <= 54;
        memory[110] <= 60;
        memory[111] <= 66;
        memory[112] <= 72;
        memory[113] <= 78;
        memory[114] <= 84;
        memory[115] <= 90;
        memory[116] <= 0;
        memory[117] <= 4;
        memory[118] <= 14;
        memory[119] <= 21;
        memory[120] <= 28;
        memory[121] <= 35;
        memory[122] <= 42;
        memory[123] <= 49;
        memory[124] <= 56;
        memory[125] <= 63;
        memory[126] <= 70;
        memory[127] <= 77;
        memory[128] <= 84;
        memory[129] <= 91;
        memory[130] <= 98;
        memory[131] <= 105;
        memory[132] <= 0;
        memory[133] <= 8;
        memory[134] <= 16;
        memory[135] <= 24;
        memory[136] <= 32;
        memory[137] <= 40;
        memory[138] <= 48;
        memory[139] <= 56;
        memory[140] <= 64;
        memory[141] <= 72;
        memory[142] <= 80;
        memory[143] <= 88;
        memory[144] <= 96;
        memory[145] <= 104;
        memory[146] <= 112;
        memory[147] <= 120;
        memory[148] <= 0;
        memory[149] <= 9;
        memory[150] <= 18;
        memory[151] <= 27;
        memory[152] <= 36;
        memory[153] <= 45;
        memory[154] <= 54;
        memory[155] <= 63;
        memory[156] <= 72;
        memory[157] <= 81;
        memory[158] <= 90;
        memory[159] <= 99;
        memory[160] <= 108;
        memory[161] <= 117;
        memory[162] <= 126;
        memory[163] <= 135;
        memory[164] <= 0;
        memory[165] <= 10;
        memory[166] <= 20;
        memory[167] <= 30;
        memory[168] <= 40;
        memory[169] <= 50;
        memory[170] <= 60;
        memory[171] <= 70;
        memory[172] <= 80;
        memory[173] <= 90;
        memory[174] <= 100;
        memory[175] <= 110;
        memory[176] <= 120;
        memory[177] <= 130;
        memory[178] <= 140;
        memory[179] <= 150;
        memory[180] <= 0;
        memory[181] <= 11;
        memory[182] <= 22;
        memory[183] <= 33;
        memory[184] <= 44;
        memory[185] <= 55;
        memory[186] <= 66;
        memory[187] <= 77;
        memory[188] <= 88;
        memory[189] <= 99;
        memory[190] <= 110;
        memory[191] <= 121;
        memory[192] <= 132;
        memory[193] <= 143;
        memory[194] <= 154;
        memory[195] <= 165;
        memory[196] <= 0;
        memory[197] <= 12;
        memory[198] <= 24;
        memory[199] <= 36;
        memory[200] <= 48;
        memory[201] <= 60;
        memory[202] <= 72;
        memory[203] <= 84;
        memory[204] <= 96;
        memory[205] <= 108;
        memory[206] <= 120;
        memory[207] <= 132;
        memory[208] <= 10;
        memory[209] <= 3;
        memory[210] <= 100;
        memory[211] <= 3;
        memory[212] <= 0;
        memory[213] <= 13;
        memory[214] <= 26;
        memory[215] <= 39;
        memory[216] <= 52;
        memory[217] <= 65;
        memory[218] <= 78;
        memory[219] <= 91;
        memory[220] <= 104;
        memory[221] <= 114;
        memory[222] <= 130;
        memory[223] <= 143;
        memory[224] <= 36;
        memory[225] <= 42;
        memory[226] <= 23;
        memory[227] <= 44;
        memory[228] <= 0;
        memory[229] <= 14;
        memory[230] <= 28;
        memory[231] <= 42;
        memory[232] <= 56;
        memory[233] <= 70;
        memory[234] <= 84;
        memory[235] <= 98;
        memory[236] <= 112;
        memory[237] <= 126;
        memory[238] <= 140;
        memory[239] <= 154;
        memory[240] <= 25;
        memory[241] <= 34;
        memory[242] <= 33;
        memory[243] <= 58;
        memory[244] <= 0;
        memory[245] <= 15;
        memory[246] <= 30;
        memory[247] <= 45;
        memory[248] <= 60;
        memory[249] <= 75;
        memory[250] <= 90;
        memory[251] <= 105;
        memory[252] <= 120;
        memory[253] <= 135;
        memory[254] <= 150;
        memory[255] <= 165;
        memory[256] <= 35;
        memory[257] <= 74;
        memory[258] <= 55;
        memory[259] <= 66;
        memory[260] <= 0;
        memory[261] <= 1;
        memory[262] <= 2;
        memory[263] <= 3;
        memory[264] <= 1;
        memory[265] <= 2;
        memory[266] <= 3;
        memory[267] <= 4;
        memory[268] <= 2;
        memory[269] <= 3;
        memory[270] <= 4;
        memory[271] <= 5;
        memory[272] <= 3;
        memory[273] <= 4;
        memory[274] <= 5;
        memory[275] <= 6;
    end

    /* Please fill in the implementation here */
    always @(posedge Clk) begin
        if (MemWrite) begin
            if (half == 2'b0) begin
                memory[Address[11:2]] <= WriteData;
            end

            else if (half == 2'b01) begin
                memory[Address[11:2]] <= WriteData[15:0];
            end
            
            else begin
                memory[Address[11:2]] <= WriteData[7:0];
            end
        end
    end


    always @(*) begin
        if (MemRead == 1) begin
            if (half == 2'b0) begin
                ReadData <= memory[Address[11:2]];
            end
            else if (half == 2'b01) begin
                if (memory[Address[11:2]][15] == 1) begin
                    ReadData <= {16'b1111111111111111, memory[Address[11:2]][15:0]};
                end
                else begin
                    ReadData <= {16'b0000000000000000, memory[Address[11:2]][15:0]};
                end
            end
            else begin
                if (memory[Address[11:2]][7] == 1) begin
                    ReadData <= {24'b111111111111111111111111, memory[Address[11:2]][7:0]};
                end
                else begin
                    ReadData <= {24'b000000000000000000000000, memory[Address[11:2]][7:0]};
                end
            end
        end
        else begin
            ReadData <= 32'b0;
        end
    end

endmodule
