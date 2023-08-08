module takePicture (shoot, clk, pxcount, button,
							rdaddress, q, rdclock,
							outstream, frameDone);
							
output reg shoot = 0;
input clk;
input [12:0] pxcount;
input button;

output reg [15:0] rdaddress = 0;
input [7:0] q;
output reg rdclock = 0;

output reg [7:0] outstream;
input frameDone;

reg released = 1;

always @(posedge clk) begin
	rdclock <= ~rdclock;							// RAM clk
	
	if (frameDone) begin
		shoot <= 0;
	end
	
	if (!button && !shoot && released) begin				//start imaging sequence when button pressed and previous shot is finished
		released <= 0;
	end else if (button && !shoot && !released) begin
		shoot <= 1;
		released <= 1;
	end
end

always @(posedge rdclock) begin
	if (pxcount == 0 && !shoot) begin			//reading out RAM data
		outstream <= q;
		rdaddress <= rdaddress + 1;
		
		if (rdaddress == 5474) begin
			rdaddress <= 0;
		end
	end
end


endmodule