`timescale 1ns / 1ps

module TopMain(
    input clk, rst, SSDClk, input [1:0] LEDSel, input [3:0] SSDSel,
    output [15:0] LED, output [6:0] LED_out, output [3:0] Anode
);
    wire btn1, btn2;
    wire [12:0] SSD;
    debouncer DB1(.clk(SSDClk), .rst(1'b0), .in(clk), .out(btn1));
    debouncer DB2(.clk(SSDClk), .rst(1'b0), .in(rst), .out(btn2));
    main CPU(.clk(btn1), .rst(btn2), .SSDClk(SSDClk), .LEDSel(LEDSel), .SSDSel(SSDSel), .LED(LED), .SSD(SSD));
    sevenSeg SSG(
.clk(SSDClk), .a(SSD), .Anode(Anode),
 .LED_out(LED_out)
);

endmodule
