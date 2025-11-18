module hazardDetectionUnit(
    input [4:0] if_id_RegisterRs1, input [4:0] if_id_RegisterRs2,
    input [4:0] id_ex_RegisterRd, input id_ex_MemRead,
    output stall
);

always @(*) begin
    if ((if_id_RegisterRs1 == id_ex_RegisterRd) || ) begin
        
    end
end
    
endmodule