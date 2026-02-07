module Timebar (
	input wire [7:0] time_left,
	output reg [5:0] bar_leds
);
	
	always @(*) begin
		case (1'b1)
			time_left > 50: bar_leds = 6'b111111; // 6 LEDs on (60-51 seconds)
			time_left > 40: bar_leds = 6'b011111; // 5 LEDs on (50-41 seconds)
			time_left > 30: bar_leds = 6'b001111; // 4 LEDs on (40-31 seconds)
			time_left > 20: bar_leds = 6'b000111; // 3 LEDs on (30-21 seconds)
			time_left > 10: bar_leds = 6'b000011; // 2 LEDs on (20-11 seconds)
			time_left > 0:  bar_leds = 6'b000001; // 1 LED on (10-1 seconds)
			default:        bar_leds = 6'b000000; // All LEDs off (0 seconds)
		endcase
	end
endmodule
