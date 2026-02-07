module RandomLED (
	input wire CLOCK_50,
	output reg [3:0] LEDR
);
	reg [25:0] counter = 0;
	reg [3:0] lfsr = 4'b0001;
	
	always @(posedge CLOCK_50) begin
		counter <= counter +1;
		
		if (counter == 50_000_000) begin
			counter <= 0;
			
			// Using Xor
			lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
			
			// select LED based on LFSR
			LEDR <= 4'b0001 << lfsr[1:0];
		end
	end
endmodule
