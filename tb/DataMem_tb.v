`timescale 1ns / 1ps

module DataMem_tb();
localparam clk_period = 10;
reg clk, MemRead, MemWrite;
reg [5:0] addr;
reg [31:0] data_in;
wire [31:0] data_out;
DataMem DM(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(addr), .data_in(data_in), .data_out(data_out));

initial begin
clk = 1'b1;
forever #(clk_period/2) clk = ~clk;
end 

initial begin 
MemRead = 1'b0;
MemWrite  = 1'b0; 
addr = 6'b000000;
data_in = 32'b00000000000000000000000000000000;
#(clk_period)
MemRead = 1'b1;
addr = 6'b000010;
#(clk_period)
MemRead = 1'b0;
addr = 6'b001110;
MemWrite = 1'b1;
data_in = 32'b00000000000000000000000001101110;
#(clk_period)
MemWrite = 1'b0;
MemRead = 1'b1;



end

endmodule
