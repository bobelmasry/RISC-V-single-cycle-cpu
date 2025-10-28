`timescale 1ns / 1ps


module ALU #(parameter N = 32) (
input [3:0] sel, input [N-1:0] a, b, output reg zero, output reg [N-1:0] out
    );


//Addition & Subtraction

wire cout1;
wire [N-1:0] addResult;
wire [N-1:0] secondOperand;
assign secondOperand =  (sel[2]) ? ~b : b;
rca #(N) RCAadd(.cin(sel[2]), .a(a), .b(secondOperand), .cout(cout1), .bitOuput(addResult));


//Anding
wire [N-1:0] andResult;
AND  #(N) And(.a(a), .b(b), .out(andResult));
//ORing 
wire [N-1:0] orResult;
OR   #(N) Or(.a(a), .b(b), .out(orResult));
    
always@(*) begin
    case(sel)
        4'b0010: begin//Addition
             out = addResult;
            zero = (addResult == 0) ? 1 : 0;
        end
        4'b0110: begin //Substraction
            out = addResult ;
            zero = (addResult == 0) ? 1 : 0;
        end
        4'b0000: begin//a ding
            out = andResult;
            zero = (andResult == 0) ? 1 : 0;
        end
        4'b0001: begin//ORing
            out = orResult;
            zero = (orResult == 0) ? 1 : 0;
        end
        default: begin
            zero = 1;
            out = 0;
        end 
        
    endcase 
end
endmodule
