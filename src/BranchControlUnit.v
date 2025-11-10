`timescale 1ns / 1ps

module BranchControlUnit(
input [2:0] funct3, input zeroSignal, carrySignal, overflowSignal, signSignal, branchSignal,
output reg BranchConfirm
    );
    always@(*) begin
        casex (funct3)
            3'b000: BranchConfirm = (branchSignal & zeroSignal); //BEQ
            3'b001: BranchConfirm = (branchSignal & ~zeroSignal); //BGE
            //Note to self - the unsigned branching system is not developed now. Will work on it later
            3'b1x0: BranchConfirm = (branchSignal & (signSignal != overflowSignal)); // BLT & BLTU
            3'b1x1: BranchConfirm = (branchSignal & (signSignal == overflowSignal)); // BGE & BGEU
            default: BranchConfirm = 0;
        endcase
    end
endmodule
