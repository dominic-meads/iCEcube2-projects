`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dominic Meads
// 
// Create Date: 11/01/2020 01:21:32 PM
// Module Name: UART_Tx_tb
// Project Name: UART_Tx
// Description: Testbench to evaluate proper serialization and timing of UART_Tx
//
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module UART_Tx_tb; 
	reg clk;               	      // 12 MHz
	reg [7:0] i_data;        	  // input data to be serialized
	reg nTx_EN;             	  // transmit enable (ACTIVE LOW)
	wire o_Tx;               	  // Serial transmit line
	wire o_RFN;              	  // RFN = ready for next (data) -- high pulse
	wire [3:0] o_sample_count;    // outputs the bit we are transmitting
	wire [10:0] o_CPB_count;      // outputs how close we are to transmitting a new bit
	
	always #41.666 clk = ~clk;  // create clk
	
	UART_Tx #(104) uut (clk,i_data,
						 nTx_EN,
						 o_Tx,
						 o_RFN,
						 o_sample_count,
						 o_CPB_count);
						
	initial 
		begin 
			clk = 0;         // init clk
			i_data = 8'h44;  // "D" (ASCII)
			nTx_EN = 1;      // Tx disabled, STATE should be IDLE or 1'b0
			#500
			nTx_EN = 0;      // enable transmit, STATE should be TRANSMIT
			#200              // 2 clock cycles
			nTx_EN = 1;
			#100000
			i_data = 8'h5A;  // "Z" (ASCII)
			#5000
			nTx_EN = 0;
			#200
			nTx_EN = 1;
			#100000
			$finish;
		end 
	endmodule
			
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
