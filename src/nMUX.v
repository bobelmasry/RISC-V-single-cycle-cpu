`timescale 1ns / 1ps

module nMUX #(parameter n = 8) (
    input sel, input [n-1:0] a, b, output [n-1:0] c
    );
    assign c = (sel) ? b : a;
endmodule
