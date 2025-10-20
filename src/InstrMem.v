`timescale 1ns / 1ps


module InstrMem(
input [5:0] addr, output [31:0] data_out
    );
    reg [31:0] memory[0:63];
    assign data_out = memory[addr];
    initial begin
        memory[0] = 32'b00000000111111110000111111110000; //0x00FF0FF0 
        memory[1] = 32'b00010010111111000001001000111010; //0x12FC123A 
        memory[2] = 32'b10101010001000101100110000110011; //0xAA22CC33 
        memory[3] = 32'b00000000100010000000100110001000; //0x00880988
        memory[45] = 32'b10111011101110111011101110111011; //0xBBBBBBBB
    end
endmodule
