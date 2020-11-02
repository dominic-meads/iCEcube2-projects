`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dominic Meads
// 
// Create Date: 11/01/2020 07:37:57 PM
// Module Name: UART_Tx_top
// Project Name: UART_Tx
// Description: Top module tying both UART_Tx and UART_Tx_test together
//
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module UART_Tx_top(
	input clk,
	output o_Tx
	);
	
	wire [7:0] w_data;
	wire w_RFN;
	wire w_nTx_EN;
	
	UART_Tx #(1250) utx0 (
		.clk(clk),
		.i_data(w_data),
		.nTx_EN(w_nTx_EN),
		.o_Tx(o_Tx),
		.o_RFN(w_RFN),
		.o_sample_count(),  // leave last two ports unconnected (sometimes helpful to see which bit being transmitted,
		.o_CPB_count()      //  and how much more time in that bit).
		);
		
	UART_Tx_test tx_tst0(
		.clk(clk),
		.i_RFN(w_RFN),
		.o_data(w_data),
		.o_nTx_EN(w_nTx_EN)
		);
		
endmodule  
