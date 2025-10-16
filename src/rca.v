`timescale 1ns / 1ps



module rca #(parameter bits = 8)
(input cin, input [bits - 1: 0] a, b, output cout, [bits - 1: 0] bitOuput
    );
    
    wire [bits - 1: 0] med;
    
    fa FullAdder(.a(a[0]), .b(b[0]), .cin(cin), .out(bitOuput[0]), .cout(med[0]));
    
    genvar i;
    generate
    for (i = 0; i < bits - 1; i = i + 1)
    begin: rca_adder
    fa FA(.a(a[i + 1]), .b(b[i + 1]), .cin(med[i]),
     .out(bitOuput[i + 1]), .cout(med[i + 1])); 
    end
    
    endgenerate
    
    assign cout = med[bits - 1];
endmodule
