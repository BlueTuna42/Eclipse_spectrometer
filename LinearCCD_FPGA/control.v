module upd8861 (clk, 
					f1, f2, 
					RB, clb, TG,
					pxcount, shoot, frameDone);		// UPD8861 linear CCD controll module

input clk;

output reg f1 = 0;
output reg f2 = 1;

output reg RB = 1;
output reg clb = 1;
output reg TG = 0;

input shoot;
output reg frameDone;

reg [5:0] counter = 0;
reg fclk = 0;

reg fen = 0;
reg RBen = 0;

reg startframe = 1;

output reg [12:0] pxcount = 5474;
reg [9:0] tgcount = 0;
reg [7:0] rbcount = 0;

/*initial begin
	f1 = 0;
	f2 = 1;
	RB = 1;
	CLB = 1;
	TG = 0;
end*/

always @(posedge clk) begin				// !!! All logic is inverted because CCD is connected through inverters !!!
	if (shoot) begin
		frameDone <= 0;				//frame in progress
		if (counter == 24) begin
			if (fen) begin		//f1 f2 oscilation and TG
				f1 <= ~f1;
				f2 <= ~f2;
		
				if (f1) begin
					RBen <= 1;
					pxcount <= pxcount + 1;
				end
			end	
	
			fclk <= ~fclk;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
		
		if (pxcount == 0 && startframe) begin			//TG enable at the begginig of the new frame
			if (tgcount == 0) begin				//delay from the last CLB rise
				fen <= 0;
				TG <= 1;
			end else if (tgcount == 30) begin		//t12
				TG <= 0;
			end else if (tgcount == 530) begin		//t18
				TG <= 1;
			end 
			
			if (tgcount == 550) begin		//begin new frame
				counter <= 0;
				f1 <= 0;
				f2 <= 1;
				fen <= 1;
				RBen <= 1;
				tgcount <= 0;
				startframe <= 0;
			end else begin 
				tgcount <= tgcount + 1;
			end			
		end
	
	
	
		if (RBen) begin		//RB CLB oscilation
			if (rbcount == 0) begin
				RB <= 1;
			end else if (rbcount == 9) begin
				RB <= 0;
			end else if (rbcount == 12) begin
				clb <= 1;
			end
			
			if (rbcount == 21) begin
				clb <= 0;
				rbcount <= 0;
				RBen <= 0;
			end else begin
				rbcount <= rbcount + 1;
			end
		end
	
	
	
		if (pxcount == 5474 && !RBen) begin			//TG enable at the end of the frame
			if (tgcount == 0) begin				//delay from the last CLB rise
				fen <= 0;
				TG <= 1;
			end else if (tgcount == 30) begin		//t12
				TG <= 0;
			end else if (tgcount == 530) begin		//t18
				TG <= 1;
			end 
			
			if (tgcount == 550) begin		//begin new frame
				counter <= 0;
				f1 <= 0;
				f2 <= 1;
//				fen <= 1;
				RBen <= 0;
				tgcount <= 0;
				pxcount <= 0;
				frameDone <= 1;
				startframe <= 1;
			end else begin 
				tgcount <= tgcount + 1;
			end			
		end
	end
end

endmodule