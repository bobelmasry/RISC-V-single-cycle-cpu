`timescale 1ns / 1ps

module Register #(parameter n = 8)(
input clk, load, rst, [n-1:0] D, output [n-1:0] Q
    );
    wire [n-1:0] med;
    genvar i;
    for(i = 0; i < n; i = i + 1)
    begin: DFlipFlop 
        TwoMUX twoM(.a(Q[i]),.b(D[i]),.sel(load), .c (med[i]));
        DFF dff(.clk(clk), .rst(rst), .D(med[i]), .Q(Q[i]) );
    end
    
endmodule
