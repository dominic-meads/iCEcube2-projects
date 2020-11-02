
`timescale 1ns / 1ps

module tb;
	reg clk, Tx_EN;
	reg [7:0] data;
	wire Tx, RFN;
	
	always # 41.6667 clk = ~clk;
	
	UART_Tx uut( .clk(clk), .Tx_EN(Tx_EN), .data(data), .Tx(Tx), .RFN(RFN) );
	
	initial 
		begin
			//$dumpfile("dump.vcd");
			//$dumpvars(0,uut);
			
			clk = 0;
			Tx_EN = 0;
			data = 8'hAF;
			#5000
			Tx_EN = 1;  // just high for a single clock pulse
			#83.3333
			Tx_EN = 0;
			#14567282
			
			
			data = 8'hFB;
			Tx_EN = 0;
			#5000
			Tx_EN = 1;
			#83.3333
			Tx_EN = 0;
			#2000000
			
			
			data = 8'h1D;
			Tx_EN = 0;
			#5000
			Tx_EN = 1;
			#83.3333
			Tx_EN = 0;
			#18980000;
			
			data = 8'hE4;
			Tx_EN = 0;
			#5000
			Tx_EN = 1;
			#83.3333
			Tx_EN = 0;
			#1898000;
			
			data = 8'h23;
			Tx_EN = 0;
			#5000
			Tx_EN = 1;
			#83.3333
			Tx_EN = 0;
			#18980000;
			
			
			
			$finish;
		end 
		
endmodule
