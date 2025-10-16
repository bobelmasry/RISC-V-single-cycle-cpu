`timescale 1ns / 1ps

module nBitShift_tb(
    );
reg [7:0] in;
wire [7:0] out;
nBitShift shifter (.in(in), .out(out));
initial begin
in = 8'b00111100;
#10 
in = 8'b11000000;
end
endmodule
