module VGAWhackAMole(
    input  CLOCK_50,
    input  [1:0] mole_index,    // from WhackAMole game

    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output       VGA_HS,
    output       VGA_VS,
    output       VGA_BLANK_N,
    output       VGA_SYNC_N,
    output       VGA_CLK
);

    // ======================
    // VGA Sync Generator
    // ======================
    wire [9:0] x_raw;
    wire [9:0] y_raw;
    wire display_area;

    vga_sync sync_inst(
        .clk50(CLOCK_50),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .display_area(display_area),
        .x(x_raw),
        .y(y_raw),
        .vga_blank_n(VGA_BLANK_N),
        .vga_sync_n(VGA_SYNC_N),
        .vga_clk(VGA_CLK)
    );

    // ======================
    // Coordinate Adjustment
    // ======================
    // shift visible coordinates so (0,0) = top-left of visible area
    wire [9:0] x = x_raw - 144;
    wire [9:0] y = y_raw - 35;

    // ======================
    // Ball Positions
    // ======================
    localparam Y_CENTER = 240;
    localparam R = 30;

    localparam X1 = 80;   
    localparam X2 = 240;  
    localparam X3 = 400;  
    localparam X4 = 560;  

    // Draw the active ball from game
    wire ball1 = (mole_index == 0) && ((x - X1)*(x - X1) + (y - Y_CENTER)*(y - Y_CENTER) <= R*R);
    wire ball2 = (mole_index == 1) && ((x - X2)*(x - X2) + (y - Y_CENTER)*(y - Y_CENTER) <= R*R);
    wire ball3 = (mole_index == 2) && ((x - X3)*(x - X3) + (y - Y_CENTER)*(y - Y_CENTER) <= R*R);
    wire ball4 = (mole_index == 3) && ((x - X4)*(x - X4) + (y - Y_CENTER)*(y - Y_CENTER) <= R*R);

    // Divider lines (always visible)
    wire line1 = (x >= 158 && x < 163);
    wire line2 = (x >= 318 && x < 323);
    wire line3 = (x >= 478 && x < 483);

    wire draw_ball = (x<640 && y<480) && (ball1 || ball2 || ball3 || ball4);
    wire draw_line = line1 || line2 || line3;

    // ======================
    // VGA Color Output
    // ======================
    assign VGA_R = (display_area && (draw_ball || draw_line)) ? 8'hFF : 8'h00;
    assign VGA_G = (display_area && draw_ball) ? 8'h00 : 8'h00;
    assign VGA_B = (display_area && draw_ball) ? 8'h00 : 8'h00;

endmodule
