-- UART Transmitter and Reciever
--
-- Receives Serial data from UART stream when "rx_en" is high
-- Receive is complete when "rx_complete" goes high, top module 
-- buffers data little bit, then transmitts same data over the 
-- UART_Tx line (echo)
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
    rx_en       : in std_logic;
    rx_in       : in std_logic;
    tx_out      : out std_logic
  );
end entity;

architecture rtl of UART_top is 

  -- internal signals
  signal w_rx_data : std_logic_vector(7 downto 0);
  signal w_tx_data : std_logic_vector(7 downto 0);
  signal w_rx_complete : std_logic;
  signal w_tx_complete : std_logic;

  -- buffer registers
  signal r_buff_0 : std_logic_vector(7 downto 0) := (others => '0');
  signal r_buff_1 : std_logic_vector(7 downto 0) := (others => '0');
  signal r_buff_2 : std_logic_vector(7 downto 0) := (others => '0');
  signal r_buff_3 : std_logic_vector(7 downto 0) := (others => '0');

begin

  i_UART_Tx_0 : entity work.UART_Tx(rtl)
    port map(
      clk         => clk,
      rst_n       => rst_n,
      tx_en       => tx_en,
      tx_data     => w_tx_data,
      tx_out      => tx_out,
      tx_complete => w_tx_complete
    );

  i_UART_Rx_0 : entity work.UART_Rx(rtl)
    port map(
      clk         => clk,
      rst_n       => rst_n,
      rx_en       => rx_en,
      rx_in       => rx_in,
      rx_data     => w_rx_data,
      rx_complete => w_rx_complete
    );

  process (clk, rst_n) is 
  begin 
    if rising_edge (clk) then 
      if rst_n <= '0' then 
        r_buff_0 <= (others => '0');
        r_buff_1 <= (others => '0');
        r_buff_2 <= (others => '0');
        r_buff_3 <= (others => '0');
      else 
        if w_rx_complete = '1' then 
          r_buff_0 <= w_rx_data;
          r_buff_1 <= r_buff_0;
          r_buff_2 <= r_buff_1;
          r_buff_3 <= r_buff_2;
        end if;
      end if;
    end if;
  end process;

  process (clk) is 
  begin 
    if rising_edge(clk) then 
      if w_tx_complete = '1' then 
        w_tx_data <= r_buff_3;
      end if;
    end if;
  end process;

end architecture;