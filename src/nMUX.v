`timescale 1ns / 1ps

module nMUX #(n = 8) (
    input sel, [n-1:0] a, b, output [n-1:0] c
    );
    assign c = (sel) ? b : a;
endmodule
