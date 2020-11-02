`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dominic Meads
// 
// Create Date: 11/01/2020 07:38:45 PM
// Module Name: UART_Tx_top_tb
// Project Name: UART_Tx
// Description: Testbench for UART_Tx_top 
//
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module UART_Tx_top_tb;
	reg clk;
	wire o_Tx;
	
	always #41.666 clk = ~clk;  // 12 MHz clk
	
	UART_Tx_top uut(clk,o_Tx);
	
	initial 
		begin 
			clk = 0;
			#400000
			$finish;
		end 
endmodule 
