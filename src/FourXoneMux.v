`timescale 1ns / 1ps
module FourXoneMux(
input [31:0] op0, op1, op2, op3, input [1:0] sel, output [31:0] out
    );
    reg [31:0] result;
    always@(*) begin
        case (sel)
            2'b00: result = op0;
            2'b01: result = op1;
            2'b10: result = op2;
            2'b11: result = op3;
            default: result = 32'b0;
        endcase
    end
    assign out = result;
endmodule
