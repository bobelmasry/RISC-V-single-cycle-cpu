module forwardingUnit (
    input ex_mem_RegWrite, input [4:0] ex_mem_RegisterRd,
    input [4:0] id_ex_RegisterRs1, input [4:0] id_ex_RegisterRs2,
    input mem_wb_RegWrite, input [4:0] mem_wb_RegisterRd,
    output reg [1:0] forwardA, output reg [1:0] forwardB
);
    

    
    always @(*) begin
        // default values
        forwardA = 2'b00;
        forwardB = 2'b00;        
        // EX hazards
        if (ex_mem_RegWrite && (ex_mem_RegisterRd != 0) &&
        (ex_mem_RegisterRd == id_ex_RegisterRs1)) begin
            forwardA = 2'b10;
        end

        if (ex_mem_RegWrite && (ex_mem_RegisterRd != 0) &&
        (ex_mem_RegisterRd == id_ex_RegisterRs2)) begin
            forwardB = 2'b10;
        end

        // MEM hazards
        if (mem_wb_RegWrite && (mem_wb_RegisterRd != 0) &&
        (mem_wb_RegisterRd == id_ex_RegisterRs1) && 
        ~(ex_mem_RegWrite && (ex_mem_RegisterRd != 0) && ex_mem_RegisterRd == id_ex_RegisterRs1)) begin
            forwardA = 2'b01;
        end

        if (mem_wb_RegWrite && (mem_wb_RegisterRd != 0) &&
        (mem_wb_RegisterRd == id_ex_RegisterRs2) &&
        ~(ex_mem_RegWrite && (ex_mem_RegisterRd != 0) && ex_mem_RegisterRd == id_ex_RegisterRs2)) begin
            forwardB = 2'b01;
        end

    end
    
endmodule

//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/08/2022 09:05:00 AM
// Design Name:
// Module Name: forward_unit
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

/*
ID/EX.RegisterRs1
ID/EX.RegisterRs2
EX/MEM.RegisterRd
MEM/WB.RegisterRd
EX/MEM.RegWrite,
MEM/WB.RegWrite.

*/
//module forwardingUnit(output reg [1:0] fowA, fowB, input EX_regWrite, MEM_regWrite,
//                    input [4:0] ID_rs1, ID_rs2, EX_rd, MEM_rd);

//      always@(*) begin
//        if(EX_regWrite == 1 && EX_rd != 0 && EX_rd == ID_rs1)
//            fowA = 2;
//        else if(MEM_regWrite == 1 && MEM_rd != 0 && MEM_rd == ID_rs1)
//            fowA = 1;
//        else
//            fowA = 0;
//      end
     
//      always@(*) begin
//        if(EX_regWrite == 1 && EX_rd != 0 && EX_rd == ID_rs2)
//            fowB = 2;
//        else if(MEM_regWrite == 1 && MEM_rd != 0 && MEM_rd == ID_rs2)
//            fowB = 1;
//        else
//            fowB = 0;        
//      end
     
//endmodule