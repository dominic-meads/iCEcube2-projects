-- UART Transmitter and Reciever
--
-- Takes in 8 bit vector and transmits over UART when "tx_en" is high. 
-- Transmission is complete when "tx_complete" goes high
-- Receives Serial data from UART stream when "rx_en" is high
-- Receive is complete when "rx_complete" goes high
-- 
-- UART Settings:
-- 9600 Baud
-- 8 data bits
-- No parity
-- 1 stop bit
--
-- Ver 1.0 Dominic Meads 2/7/2025

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_top is 
  port (
    clk         : in std_logic;  -- 12 MHz clk
    rst_n       : in std_logic;
    tx_en       : in std_logic;
    tx_out      : out std_logic;
    tx_complete : out std_logic
  );
end entity;

architecture rtl of UART_top is 

  signal r_tx_data : std_logic_vector(7 downto 0) := x"41"; -- default tx value of ascii 'A'

begin

  i_UART_Tx_0 : entity work.UART_Tx(rtl)
    port map(
      clk         => clk,
      rst_n       => rst_n,
      tx_en       => tx_en,
      tx_data     => r_tx_data,
      tx_out      => tx_out,
      tx_complete => tx_complete
    );

end architecture;
