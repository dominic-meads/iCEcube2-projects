library IEEE;
use IEEE.std_logic_1164.all;


entity LED_ring_tb is 
end LED_ring_tb;

architecture sim of LED_ring_tb is 

  constant clk_hz : integer := 12e6;
  constant clk_period : time := 1 sec / clk_hz;
  
  signal i_clk : std_logic := '1';
  signal o_D1 : std_logic;
  signal o_D2 : std_logic;
  signal o_D3 : std_logic;
  signal o_D4 : std_logic;
  signal o_D5 : std_logic;

begin 

  DUT : entity work.LED_ring(rtl)
  port map (
    i_clk => i_clk,
    o_D1 => o_D1,
    o_D2 => o_D2,
    o_D3 => o_D3,
    o_D4 => o_D4,
    o_D5 => o_D5
    );
    
  CLK_PROC : process
  begin 
    wait for clk_period / 2;
    i_clk <= not i_clk;
  end process;
  
  STIM_PROC : process 
  begin 
    wait for 3 sec;
    wait;
  end process;

end architecture;
