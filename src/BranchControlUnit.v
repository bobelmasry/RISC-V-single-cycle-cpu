`timescale 1ns / 1ps

module BranchControlUnit(
input [2:0] funct3, input zeroSignal, carrySignal, overflowSignal, signSignal, branchSignal,
output reg BranchConfirm
    );
    always@(*) begin
        casex (funct3)
            3'b000: BranchConfirm = (branchSignal & zeroSignal); //BEQ
            3'b001: BranchConfirm = (branchSignal & ~zeroSignal); //BGE
            3'b100: BranchConfirm = (branchSignal & (signSignal != overflowSignal)); // BLT 
            3'b101: BranchConfirm = (branchSignal & (signSignal == overflowSignal)); // BGE 
            3'b110: BranchConfirm = (branchSignal & ~carrySignal); // BLTU
            3'b111: BranchConfirm = (branchSignal & carrySignal); // BGEU
            default: BranchConfirm = 0;
        endcase
    end
endmodule
