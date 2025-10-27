`timescale 1ns / 1ps


module TwoDFlipFlops (
    input clk,
    input rst,
    input d_in,
    output q2_out
);


    reg q1, q2;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            q1 <= 1'b0;
            q2 <= 1'b0;
        end else begin
            q1 <= d_in;
            q2 <= q1;
        end
    end

    assign q2_out = q2;
    
endmodule 

module synchronizer(input clk, rst, sig, output sig1);
TwoDFlipFlops sync(clk, rst, sig, sig1); 
endmodule

module debouncer(input clk, rst, in, output out);
reg q1,q2,q3;


wire outputDebouncer, outputRisingEdgeDetector;
//wire clkOut;
//clockDivider #(50_000) clkDiv(clk, rst, clkOut); 

always@(posedge clk, posedge rst) begin
 if(rst == 1'b1) begin
 q1 <= 0;
 q2 <= 0;
 q3 <= 0;
 end
 else begin
 q1 <= in;
 q2 <= q1;
 q3 <= q2;
 end
end
assign outputDebouncer = (rst) ? 0 : q1&q2&q3;
synchronizer sync(clk, rst, outputDebouncer, outputRisingEdgeDetector);
rising_edge_detector rr(clk, outputRisingEdgeDetector, rst, out);

endmodule