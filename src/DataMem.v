`timescale 1ns / 1ps

module DataMem(
    input clk,
    input MemRead,
    input MemWrite,
    input [9:0] addr,
    input [31:0] data_in,
    input [2:0] funct3,           // determines byte, half, or word
    output [31:0] data_out
);
    reg [7:0] mem[0:1023];         // byte-addressable memory
    reg [31:0] read_data;

    assign data_out = (MemRead) ? read_data : 32'b0;

    // read
    always @(*) begin
        case (funct3)
            3'b000: read_data = {{24{mem[addr][7]}}, mem[addr]};                     // lb
            3'b001: read_data = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};      // lh
            3'b010: read_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};  // lw
            3'b100: read_data = {24'b0, mem[addr]};                                  // lbu
            3'b101: read_data = {16'b0, mem[addr+1], mem[addr]};                     // lhu
            default: read_data = 32'b0;
        endcase
    end

    // write
    always @(posedge clk) begin
        if (MemWrite) begin
            case (funct3)
                3'b000: mem[addr] <= data_in[7:0];                       // sb
                3'b001: begin                                            // sh
                    mem[addr]   <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                end
                3'b010: begin                                            // sw
                    mem[addr]   <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                    mem[addr+2] <= data_in[23:16];
                    mem[addr+3] <= data_in[31:24];
                end
            endcase
        end
    end

    // Initialize memory
    integer i;
    initial begin
        for (i=0; i<1024; i=i+1) mem[i] = 8'b0; // clear all bytes
        //Code
        
        //lw x1, 512(x0)- 0x20002083
        mem[0] = 8'h83;
        mem[1] = 8'h20;
        mem[2] = 8'h00;
        mem[3] = 8'h20;
        //lw x2, 516(x0) - 0x20402103
        mem[4] = 8'h03;
        mem[5] = 8'h21;
        mem[6] = 8'h40;
        mem[7] = 8'h20;
        //lw x3, 520(x0) - 0x20802183
        mem[8] = 8'h83;
        mem[9] = 8'h21;
        mem[10] = 8'h80;
        mem[11] = 8'h20;
        //or x4, x1, x2 - 0x0020e233
        mem[12] = 8'h33;
        mem[13] = 8'hE2;
        mem[14] = 8'h20;
        mem[15] = 8'h00;
        //beq x4, x3, 8 - 0x00320463
        mem[16] = 8'h63;
        mem[17] = 8'h04;
        mem[18] = 8'h32;
        mem[19] = 8'h00;
        //add x3, x1, x2 - 0x002081b3
        mem[20] = 8'hB3;
        mem[21] = 8'h81;
        mem[22] = 8'h20;
        mem[23] = 8'h00;
        //add x5, x3, x2 - 0x002182b3
        mem[24] = 8'hB3;
        mem[25] = 8'h82;
        mem[26] = 8'h21;
        mem[27] = 8'h00;
        //sw x5, 524(x0) - 0x20502623
        mem[28] = 8'h23;
        mem[29] = 8'h26;
        mem[30] = 8'h50;
        mem[31] = 8'h20;
        //lw x6, 524(x0) - 0x20c02303
        mem[32] = 8'h03;
        mem[33] = 8'h23;
        mem[34] = 8'hC0;
        mem[35] = 8'h20;
        //and x7, x6, x1 - 0x001373b3
        mem[36] = 8'hB3;
        mem[37] = 8'h73;
        mem[38] = 8'h13;
        mem[39] = 8'h00;
        //sub x8, x1, x2 - 0x40208433
        mem[40] = 8'h33;
        mem[41] = 8'h84;
        mem[42] = 8'h20;
        mem[43] = 8'h40;
        //add x0, x1, x2 - 0x00208033
        mem[44] = 8'h33;
        mem[45] = 8'h80;
        mem[46] = 8'h20;
        mem[47] = 8'h00;
        //add x9, x0, x1 - 0x001004b3
        mem[48] = 8'hB3;
        mem[49] = 8'h04;
        mem[50] = 8'h10;
        mem[51] = 8'h00;
        //Ecall - 0x00000073
        mem[52] = 8'h73;
        
        
        /////Data
        mem[512] = 8'd17;
        mem[516] = 8'd9;
        mem[520] = 8'd25;
        /*
        mem[0]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
        memory[1]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
        memory[2]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
        memory[3]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
        memory[4]=32'b00000000001100100000010001100011; //beq x4, x3, 8
        memory[5]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
        memory[6]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
        memory[7]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
        memory[8]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
        memory[9]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
        memory[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
        memory[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
        memory[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
        */
        
    end
endmodule
