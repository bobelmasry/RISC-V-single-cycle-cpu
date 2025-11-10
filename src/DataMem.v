`timescale 1ns / 1ps

module DataMem(
    input clk,
    input MemRead,
    input MemWrite,
    input [5:0] addr,
    input [31:0] data_in,
    input [2:0] funct3,           // determines byte, half, or word
    output [31:0] data_out
);
    reg [7:0] mem[0:255];         // byte-addressable memory
    reg [31:0] read_data;

    assign data_out = (MemRead) ? read_data : 32'b0;

    // read
    always @(*) begin
        case (funct3)
            3'b000: read_data = {{24{mem[addr][7]}}, mem[addr]};                     // lb
            3'b001: read_data = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};      // lh
            3'b010: read_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};  // lw
            3'b100: read_data = {24'b0, mem[addr]};                                  // lbu
            3'b101: read_data = {16'b0, mem[addr+1], mem[addr]};                     // lhu
            default: read_data = 32'b0;
        endcase
    end

    // write
    always @(posedge clk) begin
        if (MemWrite) begin
            case (funct3)
                3'b000: mem[addr] <= data_in[7:0];                       // sb
                3'b001: begin                                            // sh
                    mem[addr]   <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                end
                3'b010: begin                                            // sw
                    mem[addr]   <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                    mem[addr+2] <= data_in[23:16];
                    mem[addr+3] <= data_in[31:24];
                end
            endcase
        end
    end

    // Initialize memory
    integer i;
    initial begin
        for (i=0; i<256; i=i+1) mem[i] = 8'b0; // clear all bytes
        mem[0] = 17;
        mem[1] = 9;
        mem[2] = 25;
    end
endmodule
