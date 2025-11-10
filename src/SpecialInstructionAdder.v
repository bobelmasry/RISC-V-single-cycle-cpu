`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 09:31:13 PM
// Design Name: 
// Module Name: SpecialInstructionAdder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Special adder for the instructions LUI, AUIPC, JAL, JALR purposes
module SpecialInstructionAdder(
input [31:0] Immediate, PC, PC_Add4, [1:0] sel, output reg [31:0] result
    );
    
    always@(*) begin
        casex (sel)
            2'b00: result = Immediate; //Add 0, in case of LUI
            2'b01: result = PC + Immediate; //AUIPC
            2'b1x: result = PC_Add4; // JALR & JAL
            default: result = 0;
        endcase
    end
    
endmodule
