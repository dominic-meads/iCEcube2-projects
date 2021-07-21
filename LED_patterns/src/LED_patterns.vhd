----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Dominic Meads
-- 
-- Create Date: 07/17/2021 23:07:31 PM
-- Design Name: 
-- Module Name: LED_patterns - rtl
-- Project Name: LED_patterns
-- Target Devices: ICE40HX1K
-- Tool Versions: 
-- Description: Implements a few different light patterns on the LEDs of a 
--              lattice iCEstick FPGA board. Each pattern is displayed for 
--              two seconds. 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity LED_patterns is 
  port (
    i_clk  : in  std_logic;  -- 12 MHz
    o_LEDs : out std_logic_vector(4 downto 0)  
    );
end LED_patterns;

architecture rtl of LED_patterns is

  -- enables for different patterns/counters
  signal r_patt1_cntr_en : std_logic := '1';
  signal r_patt2_cntr_en : std_logic := '0';
  signal r_patt3_cntr_en : std_logic := '0';
  signal r_patt4_cntr_en : std_logic := '0';
  
  -- pattern counters 
  signal r_patt1_cntr : integer range 0 to 750e3 := 0;
  signal r_patt1_alt_cntr : integer range 0 to 3 := 0;
  
  -- indicates if pattern should be changed
  signal r_change_pattern : std_logic := '0';
  
  signal r_clk_cntr : integer range 0 to 24e6 := 0;
 
  -- FSM
  type t_state is (RST, PATT1, PATT2, PATT3, PATT4);
  signal STATE : t_state;



begin 

  -- display each pattern for 2 seconds (12 MHz clk * 2 = 24M counts)
  DISP_PATT_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_clk_cntr < 24e6 then 
        r_clk_cntr <= r_clk_cntr + 1;
      else 
        r_clk_cntr <= 0;
      end if;
    end if;
  end process;
  
  -- activate the "r_change_pattern" flag every 2 seconds
  r_change_pattern <= '1' when r_clk_cntr = 24e6 else '0';
  
  -- pattern 1 counter keeps each LED on in pattern 1 for 62.5 ms
  PATT1_CNTR_PROC : process(i_clk, r_patt1_cntr_en)
  begin 
    if rising_edge(i_clk) then 
      if r_patt1_cntr_en = '0' then 
        r_patt1_cntr <= 0;
      else 
        if r_patt1_cntr < 750e3 then 
          r_patt1_cntr <= r_patt1_cntr + 1;
        else 
          r_patt1_cntr <= 0;
        end if;
      end if;
    end if;
  end process;
  
    -- pattern 1 alt counter signals when to switch LEDs every 62.5 ms
  PATT1_ALT_CNTR_PROC : process(i_clk, r_patt1_cntr_en, r_patt1_cntr)
  begin 
    if rising_edge(i_clk) then 
      if r_patt1_cntr_en = '0' then 
        r_patt1_alt_cntr <= 0;
      else 
        if r_patt1_cntr = 750e3 then 
          if r_patt1_alt_cntr < 3 then 
            r_patt1_alt_cntr <= r_patt1_alt_cntr + 1;
          else 
            r_patt1_alt_cntr <= 0;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  
      
      
  



end architecture;
    
    
