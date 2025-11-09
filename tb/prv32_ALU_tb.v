`timescale 1ns / 1ps

module prv32_ALU_tb;
    reg  [31:0] a, b;
    reg  [4:0]  shamt;
    reg  [3:0]  alufn;
    wire [31:0] r;
    wire cf, zf, vf, sf;

    prv32_ALU dut (
        .a(a),
        .b(b),
        .shamt(shamt),
        .r(r),
        .cf(cf),
        .zf(zf),
        .vf(vf),
        .sf(sf),
        .alufn(alufn)
    );

    initial begin
        a = 32'd10; b = 32'd5; shamt = 5'd1; alufn = 4'b0000; #10;
        a = 32'd10; b = 32'd5; shamt = 5'd1; alufn = 4'b0001; #10;
        a = 32'd10; b = 32'd5; shamt = 5'd1; alufn = 4'b0011; #10;
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; shamt = 5'd2; alufn = 4'b0100; #10;
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; shamt = 5'd2; alufn = 4'b0101; #10;
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; shamt = 5'd2; alufn = 4'b0111; #10;
        a = 32'd8; b = 32'd2; shamt = 5'd1; alufn = 4'b1000; #10;
        a = 32'd8; b = 32'd2; shamt = 5'd1; alufn = 4'b1001; #10;
        a = 32'd8; b = 32'd2; shamt = 5'd1; alufn = 4'b1010; #10;
        a = 32'h80000000; b = 32'h7FFFFFFF; shamt = 5'd0; alufn = 4'b1101; #10;
        a = 32'hFFFFFFFF; b = 32'h00000001; shamt = 5'd0; alufn = 4'b1111; #10;
        $finish;
    end
endmodule
