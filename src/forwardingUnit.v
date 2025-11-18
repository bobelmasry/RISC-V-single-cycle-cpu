module forwardingUnit (
    input ex_mem_RegWrite, input [4:0] ex_mem_RegisterRd,
    input [4:0] id_ex_RegisterRs1, [4:0] input id_ex_RegisterRs2,
    input mem_wb_RegWrite, input [4:0] mem_wb_RegisterRd,
    output [1:0] forwardA, output [1:0] forwardB
);
    // default values
    forwardA = 2'b00;
    forwardB = 2'b00;
    
    always @(*) begin
        
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