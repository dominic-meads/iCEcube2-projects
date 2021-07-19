----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Dominic Meads
-- 
-- Create Date: 07/18/2021 20:53 PM
-- Design Name: 
-- Module Name: LED_patterns_tb - sim
-- Project Name: LED_patterns
-- Target Devices: ICE40HX1K
-- Tool Versions: 
-- Description: TESTBENCH -- Implements a few different light patterns on the LEDs of a 
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


entity LED_patterns_tb is 
end LED_patterns_tb;

architecture sim of LED_patterns_tb is 

  constant clk_hz : integer := 12e6;
  constant clk_period : time := 1 sec / clk_hz;
  
  -- DUT signals 
  signal i_clk  : std_logic := '0';  
  signal i_rst  : std_logic;
  signal o_LEDs : std_logic_vector(4 downto 0);

begin

  DUT : entity work.LED_patterns(rtl)
  port map (
    i_clk => i_clk,
    i_rst => i_rst,
    o_LEDs => o_LEDs
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
