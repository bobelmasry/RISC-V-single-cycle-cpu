module hazardDetectionUnit(
    input [4:0] if_id_RegisterRs1, input [4:0] if_id_RegisterRs2,
    input [4:0] id_ex_RegisterRd, input id_ex_MemRead,
    input mem_memRead, input mem_memWrite,
    output reg stall
);

always @(*) begin
    stall = 0;
    if (((if_id_RegisterRs1 == id_ex_RegisterRd) || (if_id_RegisterRs2 == id_ex_RegisterRd))
    && (id_ex_MemRead && (id_ex_RegisterRd != 5'b00000))) begin
        stall = 1;
    end
    if (mem_memRead || mem_memWrite) begin
        stall = 1;
    end
end
    
endmodule