module ADCread (adclk, cdsclk1, cdsclk2, analogData,
				clb,
				shoot, pxcount, clk,
				data, wraddress, wrclock, wren);

output reg adclk = 0;
output reg cdsclk1 = 0;
output reg cdsclk2 = 0;
input [7:0] analogData;

input clb;
input shoot;
input [12:0] pxcount;
input clk;

output reg [7:0] data = 0;
output reg [15:0]  wraddress = 0;
output reg wrclock = 0;
output reg wren = 0;

//CCD frequency is 1 MHz
reg [4:0] counter = 0;
reg [4:0] cds2counter = 0;
reg cds2start = 0;
reg cds2en = 0;

always @(posedge clk) begin
	if (shoot) begin
		if (counter == 3) begin			// clock generation
			wrclock = ~wrclock;
		end 
		if (counter == 7) begin
			wrclock = ~wrclock;
			adclk = ~adclk;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	
		cdsclk1 <= clb;			// CLB is used as cds1 to save LE
		if (clb == 1) begin 
			cds2en <= 1;
		end else if (clb == 0 && cds2en) begin
			cds2start <= 1;
		end
	
		if (cds2start == 1) begin 
			if (cds2counter == 13) begin
				cdsclk2 <= 1;
			end 
			if (cds2counter == 18) begin
				cdsclk2 <= 0;
				cds2counter <= 0;
				cds2start <= 0;
				cds2en <= 0;
			end else begin
				cds2counter <= cds2counter + 1;
			end
		end
	end
end

always @(posedge wrclock) begin
	if (pxcount < 5474) begin			// Reading data and writing to the RAM
		wren <= 1;
		data <= analogData;
	end
	
	if (pxcount == 5474) begin
	
	end else begin
		wraddress <= wraddress + 1;
	end
end

endmodule