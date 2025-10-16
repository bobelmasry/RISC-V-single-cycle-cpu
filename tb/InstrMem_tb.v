`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 06:12:32 AM
// Design Name: 
// Module Name: InstrMem_tb
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


module InstrMem_tb();
reg[5:0] addr;
wire[31:0] instruction;
InstrMem IM(.addr(addr), .data_out(instruction));
initial begin
addr = 6'b000000;
#10
addr = 6'b000001;
#10 
addr = 6'b000010;
#10 
addr = 6'b000011;
#10 
addr = 6'b101101;
end
endmodule
