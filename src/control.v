`timescale 1ns / 1ps


module control(
input [31:0] instr, output reg branch, memRead, MemtoReg, MemWrite, ALUSrc, RegWrite, output reg [1:0] ALUOp 
    );
wire [4:0] specifier = instr[6:2];
// specifier is the last 5 bits of the instruction
always@(*) begin
    case(specifier)
        // R-type instructions
        5'b01100: begin
        assign branch = 1'b0;
        memRead = 1'b0;
        MemtoReg = 1'b0;
        ALUOp = 2'b10;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        RegWrite = 1'b1;
        end
        // Load instructions
        5'b00000: begin
        branch = 1'b0;
        memRead = 1'b1;
        MemtoReg = 1'b1;
        ALUOp = 2'b00;
        MemWrite = 1'b0;
        ALUSrc = 1'b1;
        RegWrite = 1'b1;
        end
        // store instructions
        5'b01000: begin
        branch = 1'b0;
        memRead = 1'b0;
        MemtoReg = 1'bx;
        ALUOp = 2'b00;
        MemWrite = 1'b1;
        ALUSrc = 1'b1;
        RegWrite = 1'b0;
        end
        // branch instructions
        5'b11000: begin
        branch = 1'b1;
        memRead = 1'b0;
        MemtoReg = 1'bx;
        ALUOp = 2'b01;
        MemWrite = 1'b0;
        ALUSrc = 1'b1;
        RegWrite = 1'b0;
        end
        // I-type instructions other than Load
        5'b00100: begin
        branch = 1'b0;
        memRead = 1'b0;
        MemtoReg = 1'b0;
        ALUOp = 2'b00; // not sure about this
        MemWrite = 1'b0;
        ALUSrc = 1'b1;
        RegWrite = 1'b1;
        end
        default: begin
        branch = 1'bx;
        memRead = 1'bx;
        MemtoReg = 1'bx;
        ALUOp = 2'bxx;
        MemWrite = 1'bx;
        ALUSrc = 1'bx;
        RegWrite = 1'bx;
        end
    endcase 
end
endmodule

