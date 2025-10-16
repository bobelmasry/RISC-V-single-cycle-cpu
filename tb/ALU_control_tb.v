`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 04:50:57 PM
// Design Name: 
// Module Name: ALU_control_tb
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


module ALU_control_tb();
reg [1:0] ALUop;
reg [31:0] instr;
wire [3:0] ALUsel;
ALU_control ctrl(.ALUop(ALUop), .instr(instr), .ALUsel(ALUsel));
initial begin
ALUop = 2'b00;
//instr = 32'b0Y000000000000000xxx000000000000;
instr = 32'b010000000000000000101000000000000;
#10 
instr = 32'b00000000000000000111000000000000;
#10 
ALUop = 2'b01;
instr = 32'b010000000000000000101000000000000;
#10 
instr = 32'b00000000000000000111000000000000;
#10 
ALUop = 2'b10;
instr = 32'b00000000000000000000000000000000;
#10
instr = 32'b01000000000000000000000000000000;
#10 
instr = 32'b00000000000000000111000000000000;
#10 
instr = 32'b00000000000000000110000000000000;

end

endmodule
