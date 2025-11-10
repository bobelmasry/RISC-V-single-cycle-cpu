`timescale 1ns / 1ps
`include "defines.v"

module SpecialInstructionControlUnit(
input [4:0] opcode, output reg [2:0] sel
    );
    
    always@(*) begin
        casex (opcode)
            `OPCODE_JALR: sel = 3'b111; //JALR special code
            `OPCODE_JAL: sel = 3'b110; //JAL special code
            `OPCODE_LUI: sel = 3'b100; // LUI special code 
            `OPCODE_AUIPC: sel = 3'b101; //AUIPC special code 
            deault: sel = 3'b000;
        endcase
    end
endmodule
