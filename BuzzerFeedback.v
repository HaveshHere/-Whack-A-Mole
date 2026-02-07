module BuzzerFeedback (
    input wire clk,           // 50 MHz clock
    input wire correct_hit,   // 1 pulse when correct key pressed
    input wire wrong_hit,     // 1 pulse when wrong key pressed
    input wire game_over,     // 1 pulse when game ended
    output reg buzzer_out     // Square-wave drive for buzzer
);

    reg [31:0] counter = 0;
    reg [31:0] tone_divider = 0;
    reg [31:0] duration_counter = 0;
    reg active = 0;

    always @(posedge clk) begin
        if (correct_hit) begin
            tone_divider <= 25_000_000/2000; // ~2 kHz beep
            duration_counter <= 25_000_000/10; // 0.1s
            active <= 1;
        end else if (wrong_hit) begin
            tone_divider <= 25_000_000/500; // ~500 Hz buzz
            duration_counter <= 25_000_000/10; // 0.1s
            active <= 1;
        end else if (game_over) begin
            tone_divider <= 25_000_000/1000; // ~1 kHz tone
            duration_counter <= 25_000_000*2; // 2 seconds
            active <= 1;
        end

        if (active) begin
            if (duration_counter > 0) begin
                counter <= counter + 1;
                if (counter >= tone_divider) begin
                    counter <= 0;
                    buzzer_out <= ~buzzer_out; // toggle output at half period
                end
                duration_counter <= duration_counter - 1;
            end else begin
                active <= 0;
                buzzer_out <= 0; // silence when finished
            end
        end else begin
            buzzer_out <= 0; // Idle state
        end
    end
endmodule
