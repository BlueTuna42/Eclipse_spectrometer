module linearCCD (clk, f1, f2, RB, clb, TG,
						adclk, cdsclk1, cdsclk2, analogData,
						sdata, sclk, sload,
						button, outstream);

input clk;
output f1;
output f2;
output RB;
output clb;
output TG;

inout sdata;
output adclk;
output sclk;
output sload;
output cdsclk1;
output cdsclk2;
input [7:0] analogData;

input button;
output [7:0] outstream;

wire [7:0] data;
wire [15:0] rdaddress;
wire rdclock;
wire [15:0] wraddress;
wire wrclock;
wire wren;
wire [7:0] q;

upd8861 upd8861 (.clk(clk), .f1(f1), .f2(f2), .RB(RB), .clb(clb), .TG(TG), .pxcount(pxcount), .shoot(shoot), .frameDone(frameDone));
chipRAM chipRAM (.data(data), .rdaddress(rdaddress), .rdclock(rdclock), .wraddress(wraddress), .wrclock(wrclock), .wren(wren), .q(q));
ADCread ADCread (.adclk(adclk), .cdsclk1(cdsclk1), .cdsclk2(cdsclk2), .analogData(analogData), .clb(clb), .shoot(shoot), .pxcount(pxcount), .clk(clk), .data(data), .wraddress(wraddress), .wrclock(wrclock), .wren(wren));
ADCwrite ADCwrite (.sdata(sdata), .sclk(sclk), .sload(sload), .clk(clk));
takePicture takePicture (.shoot(shoot), .clk(clk), .pxcount(pxcount), .button(button), .rdaddress(rdaddress), .q(q), .rdclock(rdclock), .outstream(outstream), .frameDone(frameDone));

endmodule