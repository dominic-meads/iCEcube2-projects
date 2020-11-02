
`timescale 1ns / 1ps

/************************************************************************/
//
//   BASIC UART transmitter for Lattice iCEstick dev board
//   
//   Serial Terminal Settings:
//		9600 baud
//		1 stop bit
//		No Parity
//		8 data bits
//
//	 Written by Dominic Meads 
//	 4/22/2020
//	 ver 1.0
//
/************************************************************************/

module UART_Tx 
	# (parameter CPB = 1250) // CPB = clocks per bit:  12 MHz / 9600 Baud = 1250
	(
	input clk,
	input [7:0] data,
	input Tx_EN,
	output Tx,
	output RFN        // RFN = ready for next (data)
	);
	
	// states
	localparam START = 0;
	localparam TRANSMIT = 1;
	localparam IDLE = 2;
	
	// state machine reg
	reg [1:0] STATE = IDLE;   // initialized state is IDLE
	
	// data reg with start and stop bits
	reg [8:0] temp = 9'b000000000;
	
	// output registers
	reg r_Tx = 1; 
	reg r_RFN = 1;
	
	// counting registers
	reg [10:0] counter = 0;
	reg [3:0] sample = 0;
	reg CE;
	
	// counters 
	always @ (posedge clk)
		begin 
			if (CE)
				begin 
					if (counter < CPB - 1)
						counter <= counter + 1;
					else 
						counter <= 0;
				end // if (CE)
			else 
				counter <= 0;  // if CE low, counter is reset to 0
		end // always
  
	always @ (posedge clk)
		begin 
			if (counter == CPB - 1)  
				begin 
					if (sample < 9)
						sample <= sample + 1;
					else
						sample <= 0;
				end // if (counter...
		end // always

		
	// state machine
	always @ (posedge clk)
		begin 
			case (STATE)
				
				START : 
					begin
						temp = {1'b1, data[7:0]}; // data plus stop bit
						CE <= 1;
						r_Tx <= 0;        // send start bit (low)
						r_RFN <= 0;       // dont load new data
						if (counter == CPB - 1)
							STATE <= TRANSMIT;
						else 
							STATE <= START; 
					end // START
					
				TRANSMIT :
					begin 
						if (sample < 9)
							r_Tx <= temp[sample];
						else 
							begin 
								r_RFN <= 1; // ready for new data
								STATE <= IDLE;
								CE <= 0;
							end // else 
					end // TRANSMIT
					
				IDLE :
					begin
						if (Tx_EN)
							STATE <= START;
						else 
							r_Tx <= 1;
					end // IDLE
					
				default :
				    begin 
				        CE <= 0;
				        STATE <= IDLE;
				    end // default
				
			endcase 
		end // always 
		
	assign Tx = r_Tx;
	assign RFN = r_RFN;
	
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
