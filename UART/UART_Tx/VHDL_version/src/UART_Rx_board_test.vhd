-- UART Receiver test
--
-- If received data is ASCII character 'A', then LED lights up green
--
-- UART Settings:
-- 9600 Baud
-- 8 data bits
-- No parity
-- 1 stop bit
--
-- Ver 1.0 Dominic Meads 2/14/2025

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Rx_board_test is 
  port (
    clk     : in std_logic;  -- 12 MHz clk
    rx_in   : in std_logic;
    led_out : out std_logic
  );
end entity;

architecture rtl of UART_Rx_board_test is 

  signal w_rx_data     : std_logic_vector(7 downto 0); 
  signal r_rx_data     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_rst_n       : std_logic := '1';  -- dont have any switches on me while writing this so tying reset high
  signal r_rx_en       : std_logic := '1';
  signal w_rx_complete : std_logic;
  signal r_led         : std_logic := '0';

begin

  i_UART_Rx_0 : entity work.UART_Rx(rtl)
    port map(
      clk         => clk,
      rst_n       => r_rst_n,
      rx_en       => r_rx_en,
      rx_data     => w_rx_data,
      rx_in       => rx_in,
      rx_complete => w_rx_complete
    );

  -- only register data is "rx_complete" is high
  INPUT_REG_PROC : process(clk) is 
  begin 
    if rising_edge(clk) then 
      if w_rx_complete = '1' then 
        r_rx_data <= w_rx_data;
      end if;
    end if;
  end process INPUT_REG_PROC;
  
  LED_PROC : process(clk) is 
  begin 
    if rising_edge(clk) then 
      if r_rx_data = x"41" then 
        r_led <= '1';
      end if;
    end if;
  end process LED_PROC;

  led_out <= r_led;

end architecture;