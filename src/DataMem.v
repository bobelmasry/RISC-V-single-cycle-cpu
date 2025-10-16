`timescale 1ns / 1ps


module DataMem(input clk, input MemRead, input MemWrite,
input [5:0] addr, input [31:0] data_in, output [31:0] data_out);
    reg [31:0] mem[0:63];
    
    assign data_out = (MemRead) ? mem[addr] : 32'b00000000000000000000000000000000;
    always @(posedge clk) begin 
        if(MemWrite) mem[addr] <= data_in;
    end
    initial begin
        mem[0] = 32'b00000000111111110000111111110000; //0x00FF0FF0 
        mem[1] = 32'b00010010111111000001001000111010; //0x12FC123A 
        mem[2] = 32'b10101010001000101100110000110011; //0xAA22CC33 
        mem[3] = 32'b00000000100010000000100110001000; //0x00880988
        mem[45] = 32'b10111011101110111011101110111011; //0xBBBBBBBB
    end
endmodule
