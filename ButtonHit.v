module ButtonHit (
		input wire CLOCK_50,
		input wire [3:0] KEY,
		output reg [3:0] LEDR
);

		reg [25:0] counter =0;
		reg [3:0] lfsr = 4'b0001;
	
		always @(posedge CLOCK_50) 
		begin
		counter <= counter +1;
	
		// update mole every 1 sec
		if (counter == 50_000_000)
		begin
		counter <=0;
		lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
		LEDR <= 4'b0001 << lfsr[1:0]; // pick a random mole
	end

		// button check, we invert the active-low to  active-high
		if ((~KEY) & LEDR) begin
			LEDR <= 4'b0000; //mole disappears when hit
		end
	end
endmodule