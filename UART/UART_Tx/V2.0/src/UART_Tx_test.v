`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dominic Meads
// 
// Create Date: 11/01/2020 05:43:05 PM
// Module Name: UART_Tx_test
// Project Name: UART_Tx
// Description: Module responsible for sending ASCII data to the UART_Tx module
//              to be serialized and transmitted. Tests the real world function
//              of the module UART_Tx. Sends the string "DOM" over UART -- my name :)
//
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_Tx_test(
	input clk,            // 12 MHz
	input i_RFN,          // pulse from UART_Tx module
	output [7:0] o_data,  // ASCII data
	output o_nTx_EN       // ACTIVE LOW
	);
	
	// states
	localparam START = 4'b000;   // initialize--send "i" in ASCII (8'h69)
	localparam IDLE_D = 4'b001;  // wait for RFN pulse to send "D"
	localparam SEND_D = 4'b010;  // send "D" in ASCII  (8'h44)
	localparam IDLE_O = 4'b011;  // wait for RFN pulse to send "O"
	localparam SEND_O = 4'b100;  // send "O" in ASCII  (8'h4F)
	localparam IDLE_M = 4'b101;  // wait for RFN pulse to send "M"
	localparam SEND_M = 4'b110;  // send "M" in ASCII  (8'h4D)
	
	reg [3:0] STATE = 0;            // register for state machine
	reg [1:0] stretch_counter = 0;  // counter to stretch o_nTX_EN pulse to 2 clock cycles
	reg nstretch_counter_EN = 1;    // enable for stretch_counter (ACTIVE LOW)
	reg [7:0] r_data;               // data reg
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// counter to stretch o_nTX_EN pulse for two clock cycles
	always @ (posedge clk)
		begin
			if (!nstretch_counter_EN)
				begin 
					if (stretch_counter <= 2)                     /* counter goes up to 3 (4 counts) so nothing happens when stretch_counter = 0, 
					                                                 the pulse is low on counts 1+2, and 3 indicates the pulse is finished */
						stretch_counter <= stretch_counter + 1;      
					else 
						stretch_counter <= 0;
				end  // if (!nstretch_counter_EN)
			else 
				stretch_counter <= 0;
		end  // always 
		
	assign o_nTx_EN = (stretch_counter == 1 || stretch_counter == 2) ? 0:1;  // enable pulse low for two counts (2 clock cycles) so UART_Tx can catch it
	// end counter to stretch o_nTX_EN pulse for two clock cycles
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// FSM
	always @ (posedge clk)
		begin 
			case (STATE)
				
				START :  /* the START state is different because upon initialzation, the UART_Tx module will not indicate RFN (ready for next data), 
							even though it is ready, so the START state doesnt depend on RFN */
					begin 
						r_data <= 8'h69;           // "i"
						nstretch_counter_EN <= 0;
						if (stretch_counter == 3)  // wait for o_nTX_EN to go back high
							STATE <= IDLE_D;         
						else 
							STATE <= START;        
					end  // START
					
				IDLE_D : 
					begin 
						nstretch_counter_EN <= 1;  // disable counter
						if (i_RFN)
							begin 
								r_data <= 8'h44;           // "D"
								STATE <= SEND_D;            // Transmit "D"
							end  // if (i_RFN)
						else
							STATE <= IDLE_D;            // keep waiting for RFN pulse from UART_Tx
					end  // IDLE_D

				SEND_D :
					begin 
						nstretch_counter_EN <= 0;  // enable counter
						r_data <= 8'h44;           // "D"
						if (stretch_counter == 3)
							begin 
								nstretch_counter_EN <= 1;  // disable and reset counter
								STATE <= IDLE_O;            // Move to IDLE_O
							end  // if (stretch_counter...
						else
							begin 
								nstretch_counter_EN <= 0;
								STATE <= SEND_D;            // stay in same state
							end  // else
					end  // SEND_D
					
				IDLE_O : 
					begin 
						nstretch_counter_EN <= 1;  // disable counter
						if (i_RFN)
							begin 
								r_data <= 8'h4F;           // "O"
								STATE <= SEND_O;            // Transmit "O"
							end  // if (i_RFN)
						else
							STATE <= IDLE_O;            // keep waiting for RFN pulse from UART_Tx
					end  // IDLE_O

				SEND_O :
					begin 
						nstretch_counter_EN <= 0;  // enable counter
						r_data <= 8'h4F;           // "O"
						if (stretch_counter == 3)
							begin 
								nstretch_counter_EN <= 1;  // disable and reset counter
								STATE <= IDLE_M;            // Move to IDLE_M
							end  // if (stretch_counter...
						else
							begin 
								nstretch_counter_EN <= 0;
								STATE <= SEND_O;            // stay in same state
							end  // else
					end  // SEND_O
					
				IDLE_M : 
					begin 
						nstretch_counter_EN <= 1;  // disable counter
						if (i_RFN)
							begin 
								r_data <= 8'h4D;           // "M"
								STATE <= SEND_M;            // Transmit "M"
							end  // if (i_RFN)
						else
							STATE <= IDLE_M;            // keep waiting for RFN pulse from UART_Tx
					end  // IDLE_M

				SEND_M :
					begin 
						nstretch_counter_EN <= 0;  // enable counter
						r_data <= 8'h4D;           // "M"
						if (stretch_counter == 3)
							begin 
								nstretch_counter_EN <= 1;  // disable and reset counter
								STATE <= IDLE_D;            // Move back to to IDLE_D
							end  // if (stretch_counter...
						else
							begin 
								nstretch_counter_EN <= 0;
								STATE <= SEND_M;            // stay in same state
							end  // else
					end  // SEND_M
					
				default :
					begin 
						nstretch_counter_EN <= 1;  
						STATE <= START;
					end  // default
			endcase 
		end  // always 
		// end FSM

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// output assignments
		assign o_data = r_data;
		// end output assignments
		
endmodule  // Tx_test

	
	
	
	
