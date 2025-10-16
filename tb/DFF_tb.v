`timescale 1ns / 1ps

module DFF_tb();
localparam clk_period = 10;
reg clk;
reg load;
reg rst;
reg [7:0] num;
wire [7:0] out;
initial begin
clk = 1'b1;
forever #(clk_period/2) clk = ~clk;
end
Register #(8) Reg(.clk(clk), .load(load), .rst(rst), .D(num), .Q(out));
initial begin
#(clk_period)
load = 1'b0;
rst = 1'b1;
#(2*clk_period)
num = 8'b10010100;
rst = 1'b0;
#(clk_period)
load = 1'b1;
#(2*clk_period)
load = 1'b0;
#(clk_period)
rst = 1'b1;
#(2*clk_period)
num = 8'b0;
rst = 1'b0;
end

endmodule
