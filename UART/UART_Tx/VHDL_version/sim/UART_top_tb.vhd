-- tests the UART_top entity
-- 
-- UART Settings:
-- 9600 Baud
-- 8 data bits
-- No parity
-- 1 stop bit
--
-- Ver 1.0 Dominic Meads 2/9/2025

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_top_tb is 
end entity;

architecture sim of UART_top_tb is

  -- uut signals
  signal clk    : std_logic := '0'; -- 12 MHz board clock
  signal rst_n  : std_logic := '0';
  signal rx_en  : std_logic := '0'; 
  signal tx_en  : std_logic := '0'; 
  signal rx_in  : std_logic := '1'; -- high idle
  signal tx_out : std_logic;

  -- test data to echo back (gets received first, then transmitted back)
  signal r_test_data : std_logic_vector(7 downto 0) := x"41";

begin

  uut : entity work.UART_top(rtl)
    port map(
      clk => clk,
      rst_n => rst_n,
      rx_en => rx_en,
      tx_en => tx_en,
      rx_in => rx_in,
      tx_out => tx_out
    );

  CLK_PROC : process is
    begin 
      wait for 41.67 ns;
      clk <= not clk;
    end process CLK_PROC;

  STIM_PROC : process is 
  begin 
    rst_n <= '1';
    rx_en <= '1';
    wait for 50 ns;

    -- simulate transmission from PC to FPGA
    -- RX x"41"
    rx_in <= '0';
    wait for 104.167 us;
    rx_in <= r_test_data(0);
    wait for 104.167 us;
    rx_in <= r_test_data(1);
    wait for 104.167 us;
    rx_in <= r_test_data(2);
    wait for 104.167 us;
    rx_in <= r_test_data(3);
    wait for 104.167 us;
    rx_in <= r_test_data(4);
    wait for 104.167 us;
    rx_in <= r_test_data(5);
    wait for 104.167 us;
    rx_in <= r_test_data(6);
    wait for 104.167 us;
    rx_in <= r_test_data(7);
    wait for 104.167 us;
    rx_in <= '1';
    wait for 300 us;

    -- RX x"42"
    r_test_data <= x"42";
    rx_in <= '0';
    wait for 104.167 us;
    rx_in <= r_test_data(0);
    wait for 104.167 us;
    rx_in <= r_test_data(1);
    wait for 104.167 us;
    rx_in <= r_test_data(2);
    wait for 104.167 us;
    rx_in <= r_test_data(3);
    wait for 104.167 us;
    rx_in <= r_test_data(4);
    wait for 104.167 us;
    rx_in <= r_test_data(5);
    wait for 104.167 us;
    rx_in <= r_test_data(6);
    wait for 104.167 us;
    rx_in <= r_test_data(7);
    wait for 104.167 us;
    rx_in <= '1';
    wait for 300 us;

    -- RX x"43"
    r_test_data <= x"43";
    rx_in <= '0';
    wait for 104.167 us;
    rx_in <= r_test_data(0);
    wait for 104.167 us;
    rx_in <= r_test_data(1);
    wait for 104.167 us;
    rx_in <= r_test_data(2);
    wait for 104.167 us;
    rx_in <= r_test_data(3);
    wait for 104.167 us;
    rx_in <= r_test_data(4);
    wait for 104.167 us;
    rx_in <= r_test_data(5);
    wait for 104.167 us;
    rx_in <= r_test_data(6);
    wait for 104.167 us;
    rx_in <= r_test_data(7);
    wait for 104.167 us;
    rx_in <= '1';
    wait for 300 us;

    -- RX x"44"
    r_test_data <= x"44";
    rx_in <= '0';
    wait for 104.167 us;
    rx_in <= r_test_data(0);
    wait for 104.167 us;
    rx_in <= r_test_data(1);
    wait for 104.167 us;
    rx_in <= r_test_data(2);
    wait for 104.167 us;
    rx_in <= r_test_data(3);
    wait for 104.167 us;
    rx_in <= r_test_data(4);
    wait for 104.167 us;
    rx_in <= r_test_data(5);
    wait for 104.167 us;
    rx_in <= r_test_data(6);
    wait for 104.167 us;
    rx_in <= r_test_data(7);
    wait for 104.167 us;
    rx_in <= '1';
    wait for 300 us;

    -- enable tx
    rx_en <= '0';
    tx_en <= '1';
    wait;

  end process STIM_PROC;
  
end architecture;