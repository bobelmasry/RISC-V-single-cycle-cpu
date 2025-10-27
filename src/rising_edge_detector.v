`timescale 1ns / 1ps


module rising_edge_detector(
    input clk, inp, reset, output reg z
    );
    
    reg currentState;
    always @(posedge clk) begin
    if (reset == 0) begin
    case (inp)
     1'b0:   if (currentState == 0) z = 1'b0;
             else begin
             currentState = 0;
             z = 1'b0;
             end
    1'b1: if (currentState == 0) begin
          z = 1'b1;
          currentState = 1;
          end
          else z = 1'b0;
    endcase
    end
    
    else
        currentState = 0;
        //z = 1'b0;
    end
    
    //assign z = currentState;
    
endmodule
