module WhackAMole (
				input wire CLOCK_50,
				input wire reset,
				input wire fi_done,
				input wire [3:0] KEY,
				output [9:0] LEDR,
				output reg [6:0] HEX0,
				output reg [6:0] HEX1,
				output reg [6:0] HEX4,
				output reg [6:0] HEX5,
				output reg game_started_out,
				output reg game_over_out,
				output reg correct_hit,
				output reg wrong_hit,
				output reg game_over_hit
);
				
				reg [3:0] mole_led;
				reg [9:4] score_led;
				assign LEDR = {score_led, mole_led};
				reg [25:0] mole_counter = 0;
				reg [25:0] timer_counter = 0; 
				reg [3:0] lfsr = 4'b0001;
				reg [7:0] score = 0;
				reg [7:0] time_left = 60;
	
				reg game_started = 0; // Flag: Game is running
				reg game_over = 0;    // Flag: Game finished
		
				// Register to control game speed
				reg [25:0] speed_counter_limit;
		
				reg [3:0] key_s1, key_s2;
				reg [3:0] prevKEY;
	
				// 7-segment display function
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
						default: seg7 = 7'b1111111; // Blank display
				endcase
			endfunction
	
			// Simple synchronizer for button input
			always @(posedge CLOCK_50) begin
					key_s1 <= KEY;
					key_s2 <= key_s1;
					prevKEY <= key_s2;
		
				if (reset) begin
					prevKEY <= 4'b1111;
				end else begin
					prevKEY <= key_s2;
				end
			end
	 
			always @(posedge CLOCK_50) begin
	
				game_started_out = game_started;
				game_over_out = game_over;
	
				//Default pulses off
				correct_hit <= 0;
				wrong_hit <= 0;
				game_over_hit <= 0;
				
				if (reset) begin
					// Reset all game states and counters
					score <= 0;
					time_left <= 60;
					mole_led <= 4'b0000;
					mole_counter <= 0;
					timer_counter <= 0;
					lfsr <= 4'b0001;
					game_started <= 0;
					game_over <= 0;
					correct_hit <= 0;
					wrong_hit <= 0;
				end else begin
			
				// --- Idle mode / Waiting for user input ---
				if(!game_started && (fi_done || game_over)) begin
					if(prevKEY == 4'b1111 && KEY != 4'b1111) begin // Start game if any button is pressed
						score <= 0;
						time_left <= 60;
						mole_counter <= 0;
						timer_counter <=0;
						lfsr <= 4'b0001;
						mole_led <= 4'b0000;
						game_started <= 1;
						game_over <= 0;
						speed_counter_limit <= 50_000_000;
					end 
			end		
	  
				// --- Game running ---
				else if (game_started && !game_over) begin
			
				// --- Constant-Speed Timer (for time_left) ---
				timer_counter <= timer_counter + 1;
				if (timer_counter >= 50_000_000) begin
					timer_counter <= 0;
				if (time_left > 0) begin
					time_left <= time_left - 1;
			 end
		end
				
				// --- Game Speed Control (for moles) ---
				mole_counter <= mole_counter + 1;

				// Adjust speed based on current score
				if (score < 10) begin
					speed_counter_limit <= 50_000_000; // Approximate Mole Appearing Interval (~1 second)
				end else if (score < 20) begin
					speed_counter_limit <= 45_000_000; // Approximate Mole Appearing Interval  (~0.9 second)
				end else if (score < 30) begin
					speed_counter_limit <= 40_000_000; // Approximate Mole Appearing Interval  (~0.8 second)
				end else if (score < 40) begin
					speed_counter_limit <= 35_000_000; // Approximate Mole Appearing Interval  (0.7 second)
				end else if (score < 50) begin
					speed_counter_limit <= 30_000_000; // Approximate Mole Appearing Interval  (~0.6 second)	
				end else begin
					speed_counter_limit <= 25_000_000; // Approximate Mole Appearing Interval  (~0.5 second)
			end
			 
				// New mole when counter reaches the dynamic limit
				if (mole_counter >= speed_counter_limit) begin
					mole_counter <= 0;
		
				// Update mole position using LFSR
					lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]}; // Generate next mole position
					mole_led <= 4'b0001 << lfsr [1:0];
	
				// If timer reaches 0 -> game over
				if (time_left == 0) begin
					mole_led <= 4'b0000;
					game_over <= 1; // Activate game over mode
					game_started <= 0; // Return to idle mode
					game_over_hit <= 1; // Generate game_over_hit pulse
				end
			end
	
				// --- Hit detection ---
				
				/* Detect if a mole position button is newly pressed (debounced).
				key_s2 and prevKEY are synchronized and debounced button signals using double flip-flops
				to avoid metastability and false triggers from mechanical bouncing.
				The condition checks if the current button press (~key_s2) overlaps with mole_led position,
				but the previous button state (~prevKEY) did not, indicating a new fresh press.
				This generates a single pulse for a correct_hit event. */
				
				// correct_hit is set to 1 to generate a pulse (e.g., to produce a tone).
				// mole_led is cleared and mole_counter reset to make a new mole appear.
				
				if ( (|((~key_s2) & mole_led)) && (~|((~prevKEY) & mole_led)) && (time_left > 0) ) begin
					mole_led <=4'b0000; // Remove mole
				if(score < 99) // Increase score (max 99)
					score <= score + 1;
				correct_hit <= 1; // Generate correct_hit pulse tone
				mole_counter <= 0; // // Control how long a mole stays ON before a new one appears
			end
	
				// --- Wrong press (penalty) ---
				
				/* Detect if any button is pressed that does not correspond to an active mole position.
				   The condition ensures mole_led is ON, time_left > 0, and the previous key state was high (no previous press),
				   confirming a new wrong button press without bounce noise.
				   wrong_hit is set to 1 to generate a pulse (e.g., negative feedback tone). */

				// Penalty reduces score by 1 (down to minimum 0), resets mole_counter to refresh mole.
				
				else if ( (|(~key_s2)) && (mole_led != 4'b0000) && (time_left > 0) && (prevKEY == 4'b1111)) begin
					if(score > 0)   // prevent negative score
						score <= score - 1;
				wrong_hit <= 1; // Generate wrong_hit pulse tone
				mole_counter <= 0; // Control how long a mole stays ON before a new one appears
				end
			end
		end
	
				// --- Update 7-segment displays ---
				HEX0 <= seg7(score % 10); // Score Ones
				HEX1 <= seg7(score / 10); // Score Tens
				HEX4 <= seg7(time_left % 10); // Time Ones
				HEX5 <= seg7(time_left / 10); // Time Tens
				
				// Clear score LEDs first
				score_led <= 6'b000000;
				
				// Light up bonus LEDs based on score milestones
				if (score >= 10)  score_led[4] <= 1; 
				if (score >= 20) score_led[5] <= 1; 
				if (score >= 30) score_led[6] <= 1; 
				if (score >= 40) score_led[7] <= 1; 
				if (score >= 50) score_led[8] <= 1; 
				if (score >= 60) score_led[9] <= 1; 
		end
endmodule
