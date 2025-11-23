`timescale 1ns / 1ps

module main_tb();
localparam clk_period = 10;

reg clk;
reg rst;
reg SSDClk;
reg [1:0] LEDSel;
reg [3:0] SSDSel;
wire [15:0] LED;
wire [12:0] SSD;

initial begin
clk = 1'b1;
forever #(clk_period/2) clk = ~clk;
end

initial begin
SSDClk = 1'b1;
forever #(clk_period/2) SSDClk = ~SSDClk;
end

main MAIN(.clk(clk), .rst(rst), .LEDSel(LEDSel), .SSDSel(SSDSel), .LED(LED), .SSD(SSD));

initial begin 
rst = 1'b1;
LEDSel = 2'b00;
SSDSel = 4'b0000;
#(clk_period)
rst = 1'b0;
end

initial begin
    #100;
    $display(">>> SIMULATION RUNNING <<<");
end


integer k;
initial begin
    #2000;
   $display(">>> DUMPING REGISTER FILE <<<");
   MAIN.RF.printRegFile();
end


endmodule
