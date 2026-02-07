module LEDBlinker (
    input  wire CLOCK_50,
    output reg  [9:0] LEDR   // declare bus, even if only 1 LED used
);
    reg [25:0] counter;

    always @(posedge CLOCK_50) begin
        counter <= counter + 1;
        LEDR[0] <= counter[24];   
		  LEDR[1] <= counter[23];   
		  LEDR[2] <= counter[24];
		  LEDR[3] <= counter[23];   
		  LEDR[4] <= counter[24];
		  LEDR[5] <= counter[23];   
		  LEDR[6] <= counter[24];
		  LEDR[7] <= counter[23];   
		  LEDR[8] <= counter[24];
		  LEDR[9] <= counter[23];   	  
    end
endmodule
