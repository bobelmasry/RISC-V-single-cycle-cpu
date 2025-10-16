`timescale 1ns / 1ps

module ALU_control(
    input [1:0] ALUop, [31:0] instr, output reg [3:0] ALUsel
    );
    
    wire [2:0] fourteenToTwelve = instr[14:12];
    wire thirty = instr[30];
    wire [5:0] conCatInput = {ALUop, fourteenToTwelve, thirty};
    
    always@(*) begin
    casex (conCatInput)
        6'b00xxxx: ALUsel = 4'b0010;
        6'b01xxxx: ALUsel = 4'b0110;
        6'b100000: ALUsel = 4'b0010;
        6'b100001: ALUsel = 4'b0110;
        6'b101110: ALUsel = 4'b0000;
        6'b101100: ALUsel = 4'b0001;
   
    endcase
    end 
endmodule
