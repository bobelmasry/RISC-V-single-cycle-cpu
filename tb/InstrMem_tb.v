`timescale 1ns / 1ps


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
