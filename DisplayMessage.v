module DisplayMessage(
    input wire CLOCK_50,
    input wire reset,
    input wire game_started,
    input wire game_over,
    output reg [6:0] HEX2,
    output reg [6:0] HEX3,
	 output reg fi_done
);

    localparam S = 7'b0010010;
    localparam T = 7'b0000111;
    localparam F = 7'b0001110;
    localparam I = 7'b1111001;
    localparam BLANK = 7'b1111111;

    reg [26:0] fi_counter = 0;      // Big enough to count 2 seconds
    reg fi_shown = 0;

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            HEX3 <= S;
            HEX2 <= T;
            fi_counter <= 0;
            fi_shown <= 0;
				fi_done <= 0;
        end else begin
            if (!game_started && !game_over) begin
                // Idle mode: show ST
                HEX3 <= S;
                HEX2 <= T;
                fi_counter <= 0;
                fi_shown <= 0;
					 fi_done <= 1; // Ready to start again
            end else if (game_started && !game_over) begin
                // During game: blank
                HEX3 <= BLANK;
                HEX2 <= BLANK;
                fi_counter <= 0;
                fi_shown <= 0;
					 fi_done  <= 0;
            end else if (game_over) begin
					 fi_done <= 0;
                if (!fi_shown) begin
                    // Wait 2 seconds before showing FI
                    fi_counter <= fi_counter + 1;
                    if (fi_counter >= 100_000_000) begin // 2 sec at 50MHz
                        HEX3 <= F;
                        HEX2 <= I;
                        fi_shown <= 1;
								fi_done <= 1; // finished showing FI
                    end
                end
            end
        end
    end
endmodule

