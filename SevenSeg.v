module SevenSeg (
	input wire CLOCK_50,
	input wire [3:0] KEY,
	output reg [3:0] LEDR,
	output reg [6:0] HEX0
);

	reg [25:0] counter =0;
	reg [3:0] lfsr = 4'b0001;
	reg [3:0] score = 0;
	
	// 7-seg decoder
	function [6:0] seg7;
		input [3:0] digit;
		case (digit)
			4'd0: seg7 = 7'b1000000;
			4'd1: seg7 = 7'b1111001;
			4'd2: seg7 = 7'b0100100;
			4'd3: seg7 = 7'b0110000;
			4'd4: seg7 = 7'b0011001;
			4'd5: seg7 = 7'b0010010;
			4'd6: seg7 = 7'b0000010;
         4'd7: seg7 = 7'b1111000;
         4'd8: seg7 = 7'b0000000;
         4'd9: seg7 = 7'b0010000;
			default: seg7 = 7'b1111111; // nothing
		endcase
	endfunction
	
	always @(posedge CLOCK_50) 
	begin
		counter <= counter +1;
		
		// new mole every second
		if (counter == 50_000_000) 
		begin
			counter <= 0;
			lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
			LEDR <= 4'b0001 << lfsr[1:0];
		end
			
		// hit detection
		if ((~KEY & LEDR)) 
		begin
			LEDR <= 4'b0000;
			if (score < 9) 
				score <= score + 1;
		end
		
		// update display
		HEX0 <= seg7(score);
	end
endmodule
			