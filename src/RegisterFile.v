`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 06:18:09 PM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile #(parameter N = 32)(
input clk, rst, regWrite, input [4:0] rs1, rs2, rd, input [N-1:0] writeData, output [N-1:0] data1, data2 
    );
    integer i;
    
reg [N-1:0] regFile[31:0];
always @ (posedge clk or posedge rst)
    if (rst) begin
        for(i = 0; i < N; i=i+1)
            regFile[i] <= 0;
    end else begin
        if(regWrite == 1'b1 && rd != 5'b00000)
            regFile [rd] = writeData; 
    end
    assign data1 = regFile[rs1];
    assign data2 = regFile[rs2];
endmodule
