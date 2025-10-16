`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 06:38:41 PM
// Design Name: 
// Module Name: RegisterFile_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegisterFile_tb();
localparam clk_period = 10;
reg clk;
reg rst;
reg regWrite;
reg [4:0] rs1, rs2, rd;
reg [31:0] writeData;
wire [31:0] data1, data2;
initial begin
clk = 1'b1;
forever #(clk_period/2) clk = ~clk;
end 
RegisterFile rf(.clk(clk), .rst(rst), .regWrite(regWrite), .rs1(rs1), .rs2(rs2), .rd(rd), .writeData(writeData), .data1(data1), .data2(data2));
initial begin
#(clk_period)
rst = 1'b1;
rs1 = 5'b00000;
rs2 = 5'b00000;
rd = 5'b00000;
writeData = 32'b00000000000000000000000000000000;
regWrite = 1'b0;
//Failed Write attempt
#(clk_period)
rst = 1'b0;
rd = 5'b01000;
writeData = 32'b00000000000000000000000001111011; // 123
#(clk_period)
regWrite = 1'b1;
//read rs1 
#(clk_period)
regWrite = 1'b0;
rs1 = 5'b01000;
//write normal 
#(clk_period)
writeData = 32'b00000000000000111001001011111010; // 234234 
rd = 5'b11001;
regWrite = 1'b1;
//read rs2 
#(clk_period )
regWrite = 1'b0;
rs2 = 5'b11001;
//write 0 
#(clk_period)
writeData = 32'b00000000000000111001001011111010; // 234234 
rd = 5'b00000;
regWrite = 1'b1;
//read 0
#(clk_period )
regWrite = 1'b0;
rs2 = 5'b00000;
end

endmodule
