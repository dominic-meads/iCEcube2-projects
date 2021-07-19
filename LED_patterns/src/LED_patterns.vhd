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
    i_rst  : in  std_logic;
    o_LEDs : out std_logic_vector(4 downto 0)  
    );
end LED_patterns;

architecture rtl of LED_patterns is

  -- enables for different patterns/counters
  signal r_pattern1_en : std_logic := '0';
  signal r_pattern2_en : std_logic := '0';
  signal r_pattern3_en : std_logic := '0';
  signal r_pattern4_en : std_logic := '0';
  
  -- indicates if pattern should be changed
  signal r_change_pattern : std_logic := '0';
  
  signal r_clk_cntr : integer range 0 to 24e6 := 0;
 
  -- FSM
  type t_state is (RST, PATT1, PATT2, PATT3, PATT4);
  signal STATE : t_state;



begin 

  DISP_PATT_PROC : process(i_clk, i_rst)
  begin 
    if rising_edge(i_clk) then 
      if i_rst = '1' then 
        r_change_pattern <= '0';
        r_clk_cntr <= 0;
      else 
        if clk_cntr < 24e6 then 
          r_clk_cntr <= clk_cntr + 1;
        else 
          clk_cntr <= 0;
        end if;
      end if;
    end if;
  end process;
  



end architecture;
    
    
