module DoubleTapReset (
	input wire clk,
	input wire btn,  // Active-low button (KEY3)
	output reg reset_pulse
);

	reg prev_btn = 1 ;  // Previous button state (idle = not pressed)
	reg waiting_for_second = 0; // Flag: waiting for second tap
	reg [23:0] timer = 0;  // Timer for double-tap detection (~0.02s per increment @ 50 MHZ)
	
	always @(posedge clk) begin
		reset_pulse <= 0; // Default: no reset pulse
		
		// Detect button press (rising edge of actilve-low button)
		if (btn == 0 && prev_btn == 1) begin
		 if (!waiting_for_second) begin
		 
			// First tap detected, start waiting for second tap
			waiting_for_second <= 1; 
			timer <=0;
		 end else begin
		 
			// Second tap detected within time window -> generate reset
			reset_pulse <= 1; 
			waiting_for_second <= 0;
		 end
		 
		end 
		
		// Timing logic for double-tap detection
		else if (waiting_for_second) begin
			if (timer < 12_500_000) // ~0.25s window
				timer <= timer + 1;
			else
				waiting_for_second <= 0; // Timeout -> cancel double-tap
		end
		
		prev_btn <= btn; // Update previous button state
	  end
endmodule
