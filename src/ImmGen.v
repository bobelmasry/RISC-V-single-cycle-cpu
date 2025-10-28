`timescale 1ns / 1ps


module ImmGen(
input [31:0] instr, output [31:0] imm 
    );
    wire [1:0] op = instr[6:5];
    reg [12:0] medImm;
    always @(*) begin
        case (op)
           2'b10: medImm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; //BEQ 
           2'b11: medImm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; //BEQ 
           2'b00: medImm = {instr[31], instr[31:20]}; //LW 
           2'b01: medImm = {instr[31], instr[31:25], instr[11:7]}; //SW 
        endcase
    end
    assign imm = {{19{medImm[12]}}, medImm};
endmodule
