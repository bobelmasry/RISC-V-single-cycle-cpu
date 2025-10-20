`timescale 1ns / 1ps


module OR #(parameter N = 32)(
input [N-1:0] a, b, output [N-1:0] out
    );
    
    assign out = a | b;
endmodule
