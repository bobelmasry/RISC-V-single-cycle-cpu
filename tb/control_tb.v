`timescale 1ns / 1ps


module control_tb();
reg [31:0] instr;
wire branch, memRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
control Con(.instr(instr), .branch(branch), .memRead(memRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .ALUOp(ALUOp));
initial begin
//instr = 32'b0000000000000000000000000xxxxx00;
instr = 32'b00000000000000000000000000110000;
#10 
instr = 32'b00000000000000000000000000000000;
#10 
instr = 32'b00000000000000000000000000100000;
#10 
instr = 32'b00000000000000000000000001100000;
#10 
instr = 32'b00000000000000000000000001111100;
end
endmodule
