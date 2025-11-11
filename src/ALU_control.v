`timescale 1ns / 1ps

module ALU_control(
    input [1:0] ALUop, input [3:0] funct3to7, output reg [3:0] ALUsel
    );
    
    wire [2:0] fourteenToTwelve = funct3to7[2:0];
    wire thirty = funct3to7[3];
    wire [5:0] conCatInput = {ALUop, fourteenToTwelve, thirty};
    
    always@(*) begin
    casex (conCatInput)
        //Add (and so far the unique codes)
        6'b00xxxx: ALUsel = 4'b0000;
        6'b100000: ALUsel = 4'b0000;
        6'b11000x: ALUsel = 4'b0000;
        //Sub
        6'b100001: ALUsel = 4'b0001;
        
        //Branch (useless so far)
        6'b01xxxx: ALUsel = 4'b0110; //dummy variable
        
        
        //OR
        6'b1x110x: ALUsel = 4'b0100;
        // AND
        6'b1x111x: ALUsel = 4'b0101;
        //XOR
        6'b1x100x: ALUsel = 4'b0111;
        //SLL
        6'b1x0010: ALUsel = 4'b1000;
        //SRL
        6'b1x1010: ALUsel = 4'b1001;
        //SRA
        6'b1x1011: ALUsel = 4'b1011;
        //SLT
        6'b1x010x: ALUsel = 4'b1101;
        //SLTU
        6'b1x011x: ALUsel = 4'b1111;
    endcase
    end 
endmodule

// arithmetic
//            4'b00_00 : r = add; 
//            4'b00_01 : r = add; 
//            4'b00_11 : r = b;
//            // logic
//            4'b01_00:  r = a | b;
//            4'b01_01:  r = a & b;
//            4'b01_11:  r = a ^ b;
//            // shift
//            4'b10_00:  r=sh;
//            4'b10_01:  r=sh;
//            4'b10_10:  r=sh;
//            // slt & sltu
//            4'b11_01:  r = {31'b0,(sf != vf)}; 
//            4'b11_11:  r = {31'b0,(~cf)};       
