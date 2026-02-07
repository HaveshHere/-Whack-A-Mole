module vga_sync(
    input  clk50,           // 50 MHz clock
    output reg hsync,       // horizontal sync
    output reg vsync,       // vertical sync
    output      display_area, // high during visible area
    output reg [9:0] x,     // current pixel x (0–639)
    output reg [9:0] y,     // current pixel y (0–479)
    output      vga_blank_n,
    output      vga_sync_n,
    output      vga_clk
);

    // 25 MHz pixel clock from 50 MHz
    reg clk25 = 0;
    always @(posedge clk50) clk25 <= ~clk25;
    assign vga_clk = clk25;

    // Timing counters
    always @(posedge clk25) begin
        if (x < 799)
            x <= x + 1;
        else begin
            x <= 0;
            if (y < 524)
                y <= y + 1;
            else
                y <= 0;
        end
    end

    // Sync pulses
    always @(posedge clk25) begin
        hsync <= (x < 96) ? 0 : 1;
        vsync <= (y < 2)  ? 0 : 1;
    end

    // Visible area detection
    assign display_area = (x >= 144 && x < 784) && (y >= 35 && y < 515);

    // Derived signals
    assign vga_blank_n = display_area;
    assign vga_sync_n  = 1'b0;

endmodule
