`timescale 1ns / 1ps

module DataMem_tb();
    reg clk, MemRead, MemWrite;
    reg [5:0] addr;
    reg [31:0] data_in;
    reg [2:0] funct3;
    wire [31:0] data_out;

    DataMem DM(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .data_in(data_in),
        .funct3(funct3),
        .data_out(data_out)
    );

    task toggle_clk; begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end endtask

    initial begin
        clk = 0;
        MemRead = 0; MemWrite = 0; addr = 0; data_in = 32'b0; funct3 = 3'b010;

        // read initial memory
        MemRead = 1; addr = 0; toggle_clk;
        addr = 1; toggle_clk;
        MemRead = 0; toggle_clk;

        // write operations
        MemWrite = 1; funct3 = 3'b010; addr = 8;  data_in = 32'b11011110101011011011111011101111; toggle_clk; // word
        MemWrite = 1; funct3 = 3'b001; addr = 10; data_in = 32'b00000000000000001011101111101111; toggle_clk; // halfword
        MemWrite = 1; funct3 = 3'b000; addr = 12; data_in = 32'b00000000000000000000000011101111; toggle_clk; // byte
        MemWrite = 0; toggle_clk;

        // read back
        MemRead = 1; funct3 = 3'b010; addr = 8; toggle_clk;
        funct3 = 3'b001; addr = 10; toggle_clk; // lw
        funct3 = 3'b000; addr = 12; toggle_clk; // lb
        funct3 = 3'b100; addr = 12; toggle_clk; // lbu
        MemRead = 0; toggle_clk;

        #10 $stop;
    end
endmodule
