module vga (
    output reg [3:0] vga_r,
    output reg [3:0] vga_g,
    output reg [3:0] vga_b,
    output reg vga_hs,
    output reg vga_vs,

    input clk,
    input reset
);

    reg pix_clock;
    reg clk_2;

    reg [9:0] h_cnt;
    reg [9:0] v_cnt;

    // Clock divider 1: divide input clock by 2
    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_2 <= 1'b0;
        else
            clk_2 <= ~clk_2;
    end

    // Clock divider 2: further divide by 2
    always @(posedge clk_2 or posedge reset) begin
        if (reset)
            pix_clock <= 1'b0;
        else
            pix_clock <= ~pix_clock;
    end

    // Horizontal and vertical sync signals
    always @(*) begin
        if (h_cnt >= 656 && h_cnt < 752)
            vga_hs = 1'b0;
        else
            vga_hs = 1'b1;

        if (v_cnt == 10'd412 || v_cnt == 10'd413)
            vga_vs = 1'b1;
        else
            vga_vs = 1'b0;
    end

    // Main VGA control logic
    always @(posedge pix_clock or posedge reset) begin
        if (reset) begin
            h_cnt <= 10'd0;
            v_cnt <= 10'd0;
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
        end else begin
            // Display area (640x400)
            if (h_cnt < 640 && v_cnt < 400) begin
                // Red border
                if (h_cnt == 0 || v_cnt == 0 || h_cnt == 639 || v_cnt == 399) begin
                    vga_r <= 4'hF;
                    vga_g <= 4'h0;
                    vga_b <= 4'h0;
                end
                // White pattern
                else if (h_cnt[0] && v_cnt[1]) begin
                    vga_r <= 4'hF;
                    vga_g <= 4'hF;
                    vga_b <= 4'hF;
                end
                // Green background
                else begin
                    vga_r <= 4'h0;
                    vga_g <= 4'hF;
                    vga_b <= 4'h0;
                end
            end else begin
                // Blank outside active area
                vga_r <= 4'h0;
                vga_g <= 4'h0;
                vga_b <= 4'h0;
            end

            // Horizontal counter
            if (h_cnt < 800)
                h_cnt <= h_cnt + 1;
            else begin
                h_cnt <= 10'd0;
                // Vertical counter
                if (v_cnt < 449)
                    v_cnt <= v_cnt + 1;
                else
                    v_cnt <= 10'd0;
            end
        end
    end

endmodule

