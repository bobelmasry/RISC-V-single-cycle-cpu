`timescale 1ns / 1ps

module shifter_tb;

    reg  [31:0] a;
    reg  [4:0]  shamt;
    reg  [1:0]  type;
    wire [31:0] r;

    shifter uut (
        .a(a),
        .shamt(shamt),
        .type(type),
        .r(r)
    );

    initial begin
        type = 2'b00;
        a = 32'h0000_000F;
        shamt = 4;
        #5;

        a = 32'h0000_00FF;
        shamt = 8;
        #5;

        type = 2'b01;
        a = 32'hF000_0000;
        shamt = 4;
        #5;

        a = 32'h8000_0000;
        shamt = 8;
        #5;

        type = 2'b10;
        a = 32'hF000_0000;
        shamt = 4;
        #5;

        a = 32'h8000_0000;
        shamt = 8;
        #5;

        type = 2'b00; a = 32'h12345678; shamt = 0; #5;
        type = 2'b01; a = 32'h12345678; shamt = 0; #5;
        type = 2'b10; a = 32'h12345678; shamt = 0; #5;

        type = 2'b11;
        a = 32'hA5A5_A5A5;
        shamt = 4;
        #5;

        $stop;
    end
endmodule
