module BuzzerTester (
    input  wire clk,       // 50 MHz clock
    output reg  buzzer_out // connect this to FPGA I/O pin for buzzer
);

    // Parameters
    localparam CLK_FREQ = 50_000_000;    // 50 MHz
    localparam PWM_FREQ = 1000;          // 1 kHz tone
    localparam HALF_PERIOD = CLK_FREQ / (PWM_FREQ * 2);

    reg [31:0] counter;

    always @(posedge clk) begin
            if (counter >= HALF_PERIOD - 1) begin
                counter    <= 0;
                buzzer_out <= ~buzzer_out; // toggle output
            end else begin
                counter <= counter + 1;
            end
       
    end

endmodule
