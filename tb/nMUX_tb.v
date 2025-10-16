`timescale 1ns / 1ps


module nMUX_tb();
reg [4:0] a;
reg [4:0] b;
wire [4:0] c;
reg sel;
nMUX #(5)mux (.a(a), .b(b), .sel(sel), .c(c));
initial begin
a = 5'b01010;
b = 5'b10101;
sel = 1'b0;
#10 
sel = 1'b1;


end 
    
endmodule
