
`timescale 1ns / 1ps


module top(
	input clk,
	output Tx
	);
	
	wire [7:0] w_data;
	wire w_Tx_EN;
	wire w_RFN;
	
	UART_Tx #(1250) u1 (
		.clk(clk),
		.data(w_data),
		.Tx_EN(w_Tx_EN),
		.Tx(Tx),
		.RFN(w_RFN)
		);
		
	tx t1(
		.clk(clk),
		.Tx_EN(w_Tx_EN),
		.RFN(w_RFN),
		.data(w_data)
		);
		
endmodule 





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
	reg r_RFN = 0;
	
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
	
	






	
	
module tx(   // sends data to UART_Tx to be then serialized and sent over UART to terminal
	input clk,
	output [7:0] data,
	output Tx_EN,
	input RFN        // RFN = ready for next (data)
	);
	
	reg [7:0] r_data;
	reg r_Tx_EN;
	reg [31:0] counter;
	
	always @ (posedge clk) 
		begin 
			if( counter <= 78002)
				counter <= counter + 1;
				
			else 
				counter <= 0;
		end 
		
	
	always @ (posedge clk)
		begin 

			if (counter == 13000)
				begin 
					r_data <= 8'h48;
					r_Tx_EN <= 1; 
				end 
			else if (counter == 13001)
				r_Tx_EN <= 0;
				
			if (RFN) 
				begin 
					if (counter == 26000)
						begin 
							r_data <= 8'h45;
							r_Tx_EN <= 1; 
						end 
					else if (counter == 26001)
						r_Tx_EN <= 0;
						
					else if (counter == 39000)
						begin 
							r_data <= 8'h4C;
							r_Tx_EN <= 1; 
						end 
					else if (counter == 39001)
						r_Tx_EN <= 0;
						
					else if (counter == 52000)
						begin 
							r_data <= 8'h4C;
							r_Tx_EN <= 1; 
						end 
					else if (counter == 52001)
						r_Tx_EN <= 0;
						
						
					else if (counter == 65000)
						begin 
							r_data <= 8'h4F;
							r_Tx_EN <= 1; 
						end 
					else if (counter == 65001)
						r_Tx_EN <= 0;
						
						
					else if (counter == 78000)
						begin 
							r_data <= 8'h20;
							r_Tx_EN <= 1; 
						end 
					else if (counter == 78001)
						r_Tx_EN <= 0;
					
				end // if RFN
		end // always 
		
	assign Tx_EN = r_Tx_EN;
	assign data = r_data;
	
endmodule




/*

`timescale 1ns / 1ps 

module tb;
	reg clk;
	wire Tx;
	
	top uut(clk, Tx);
	
	always #41.667 clk = ~clk;
	
	
	initial
		begin 
			clk = 0;
			
			#7000000
			$finish; 
			
			end 
			
endmodule */
						
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
			
