module ADCwrite (sdata, sclk, sload,
						clk,
						ADCdaddres, ADCdbits, rw, start);
input clk;
input rw;
inout reg start;						
						
inout reg sdata;
output reg sclk;
output reg sload;

input [2:0] ADCdaddres;
inout reg [8:0] ADCdbits;

reg [3:0] counter = 0;
reg [3:0] bitnum = 0;

always @(posedge clk) begin		// generate Sclk
	if (counter == 9) begin
		sclk <= ~sclk;
		counter <= 0;
	end else begin
		counter <= counter + 1;
	end
end

always @(negedge sclk) begin		// send data via sdata pins
	if (start == 1) begin
		sload <= 0;
		
		case (bitnum)
				0 : sdata <= rw;
				1 : sdata <= ADCdaddres[2];
				2 : sdata <= ADCdaddres[1];
				3 : sdata <= ADCdaddres[0];
		endcase
		
		if (rw) begin			// rw == 0 read, rw == 1 write
			case (bitnum)
				7 : sdata <= ADCdbits[8];
				8 : sdata <= ADCdbits[7];
				9 : sdata <= ADCdbits[6];
				10 : sdata <= ADCdbits[5];
				11 : sdata <= ADCdbits[4];
				12 : sdata <= ADCdbits[3];
				13 : sdata <= ADCdbits[2];
				14 : sdata <= ADCdbits[1];
				15 : sdata <= ADCdbits[0];
				16 : start <= 0;
			endcase
		end else begin
			case (bitnum)
				7 : ADCdbits[8] <= sdata;
				8 : ADCdbits[7] <= sdata;
				9 : ADCdbits[6] <= sdata;
				10 : ADCdbits[5] <= sdata;
				11 : ADCdbits[4] <= sdata;
				12 : ADCdbits[3] <= sdata;
				13 : ADCdbits[2] <= sdata;
				14 : ADCdbits[1] <= sdata;
				15 : ADCdbits[0] <= sdata;
				16 : start <= 0;
			endcase
		end
		
		bitnum <= bitnum + 1;
	end else begin
		sload <= 1;
		bitnum <= 0;
	end
end

endmodule 