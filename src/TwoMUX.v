`timescale 1ns / 1ps

module TwoMUX(
    input a, b, sel, output c
    );
    
    assign c = (sel) ? b : a;
endmodule
