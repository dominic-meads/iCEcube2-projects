-- blinks LEDS on iCEstick in ring pattern

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity LED_ring is 
  port (
    i_clk : in std_logic;
    o_D1 : out std_logic;
    o_D2 : out std_logic;
    o_D3 : out std_logic;
    o_D4 : out std_logic;
    o_D5 : out std_logic
    );
end LED_ring;

architecture rtl of LED_ring is 

  signal r_clk_counter : unsigned(19 downto 0) := (others => '0');
  signal r_D_counter : unsigned(1 downto 0) := "00";

begin 

  -- input clk is 12 MHz so 1,000,000 counts is 0.08333 sec
  TIME_COUNTER_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_clk_counter < x"F4240" then 
        r_clk_counter <= r_clk_counter + 1;
      else 
        r_clk_counter <= (others => '0');
      end if;
    end if;
  end process;
  
  -- counts up once every 0.08333 sec
  D_COUNTER_PROC : process(i_clk, r_clk_counter)
  begin
    if rising_edge(i_clk) then 
      if r_clk_counter = x"F4240" then 
        if r_D_counter < "11" then 
          r_D_counter <= r_D_counter + 1;
        else 
          r_D_counter <= "00";
        end if;
      end if;
    end if;
  end process;
        
  o_D1 <= '1' when r_D_counter = 0 else '0';
  o_D2 <= '1' when r_D_counter = 1 else '0';
  o_D3 <= '1' when r_D_counter = 2 else '0';
  o_D4 <= '1' when r_D_counter = 3 else '0';
  o_D5 <= '0';
  
end architecture;
