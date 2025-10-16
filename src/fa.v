`timescale 1ns / 1ps


module fa(
    input a, b, cin,
    output out, cout
    );
    
    assign out = a ^ b ^ cin;
    assign cout = (a&b) | (b&cin) | (a&cin);  
endmodule
