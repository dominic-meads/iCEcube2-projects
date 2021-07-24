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
  signal r_patt1_en : std_logic := '1';
  signal r_patt2_en : std_logic := '0';
  signal r_patt3_en : std_logic := '0';
  signal r_patt4_en : std_logic := '0';
  
  -- pattern counters 
  signal r_patt1_cntr     : integer range 0 to 1e6 := 0;
  signal r_patt1_alt_cntr : integer range 0 to 3   := 0; 
  signal r_patt2_cntr     : integer range 0 to 1e6 := 0;
  signal r_patt2_alt_cntr : integer range 0 to 1   := 0;
  signal r_patt3_cntr     : integer range 0 to 2e6 := 0;
  signal r_patt3_alt_cntr : integer range 0 to 5   := 0;
  signal r_patt4_cntr     : integer range 0 to 2e5 := 0;
  signal r_patt4_alt_cntr : integer range 0 to 2e5 := 0;
  
  -- indicates if pattern should be changed
  signal r_change_pattern : std_logic := '0';
  
  signal r_clk_cntr : integer range 0 to 36e6 := 0;
 
  -- FSM
  type t_state is (PATT1, PATT2, PATT3, PATT4);
  signal STATE : t_state;
  
  -- output register
  signal r_LEDs : std_logic_vector(4 downto 0) := "00000";

begin 

  -- display each pattern for 2 seconds (12 MHz clk * 2 = 24M counts)
  DISP_PATT_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_clk_cntr < 36e6 then 
        r_clk_cntr <= r_clk_cntr + 1;
      else 
        r_clk_cntr <= 0;
      end if;
    end if;
  end process;
  
  -- activate the "r_change_pattern" flag every 3 seconds
  r_change_pattern <= '1' when r_clk_cntr = 36e6 else '0';
  
  -- pattern 1 counter keeps each LED on in pattern 1 for 83.333 ms
  PATT1_CNTR_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt1_en = '0' then 
        r_patt1_cntr <= 0;
      else 
        if r_patt1_cntr < 1e6 then 
          r_patt1_cntr <= r_patt1_cntr + 1;
        else 
          r_patt1_cntr <= 0;
        end if;
      end if;
    end if;
  end process;
  
    -- pattern 1 alt counter signals when to switch LEDs every 83.333 ms
  PATT1_ALT_CNTR_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt1_en = '0' then 
        r_patt1_alt_cntr <= 0;
      else 
        if r_patt1_cntr = 1e6 then 
          if r_patt1_alt_cntr < 3 then 
            r_patt1_alt_cntr <= r_patt1_alt_cntr + 1;
          else 
            r_patt1_alt_cntr <= 0;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- pattern 2 counter keeps each LED on in pattern 2 for 83.333 ms
  PATT2_CNTR_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt2_en = '0' then 
        r_patt2_cntr <= 0;
      else 
        if r_patt2_cntr < 1e6 then 
          r_patt2_cntr <= r_patt2_cntr + 1;
        else 
          r_patt2_cntr <= 0;
        end if;
      end if;
    end if;
  end process;
  
  -- pattern 2 alt counter signals when to switch LEDs every 83.33 ms
  PATT2_ALT_CNTR_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt2_en = '0' then 
        r_patt2_alt_cntr <= 0;
      else 
        if r_patt2_cntr = 1e6 then 
          if r_patt2_alt_cntr < 1 then 
            r_patt2_alt_cntr <= r_patt2_alt_cntr + 1;
          else 
            r_patt2_alt_cntr <= 0;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- pattern 3 counter keeps each LED on in pattern 2 for 166.666 ms
  PATT3_CNTR_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt3_en = '0' then 
        r_patt3_cntr <= 0;
      else 
        if r_patt3_cntr < 2e6 then 
          r_patt3_cntr <= r_patt3_cntr + 1;
        else 
          r_patt3_cntr <= 0;
        end if;
      end if;
    end if;
  end process;

  -- pattern 3 alt counter signals when to switch LEDs every 166.666 ms, but switching only lasts two times, like a heart beat
  PATT3_ALT_CNTR_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt3_en = '0' then 
        r_patt3_alt_cntr <= 0;
      else 
        if r_patt3_cntr = 2e6 then 
          if r_patt3_alt_cntr < 5 then 
            r_patt3_alt_cntr <= r_patt3_alt_cntr + 1;
          else 
            r_patt3_alt_cntr <= 0;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- creates PWM with a switching frequency of 100 Hz
  PATT4_PWM_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt4_en = '0' then 
        r_patt4_cntr <= 0;
      else 
        if r_patt4_cntr < 2e5 then 
          r_patt4_cntr <= r_patt4_cntr + 1;
        else 
          r_patt4_cntr <= 0;
        end if;
      end if;
    end if;
  end process;
  
  -- increments duty cycle in PWM (in 10 equispaced increments) to increase brightness in LEDs
  PATT4_DUTY_CYCLE_INCR_PROC : process(i_clk)
  begin 
    if rising_edge(i_clk) then 
      if r_patt4_en = '0' then 
        r_patt4_alt_cntr <= 0;
      else 
        if r_patt4_cntr = 2e5 then 
          if r_patt4_alt_cntr < 2e5 then 
            r_patt4_alt_cntr <= r_patt4_alt_cntr + 2000;
          else 
            r_patt4_alt_cntr <= 0;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  FSM_PROC : process(i_clk) 
  begin
    if rising_edge(i_clk) then 
      case STATE is 
        when PATT1 =>
          if r_change_pattern = '1' then 
            STATE <= PATT2;
            r_patt1_en <= '0';
          else 
            STATE <= PATT1;
            r_patt1_en <= '1';
          end if;
        
        when PATT2 => 
          if r_change_pattern = '1' then 
            STATE <= PATT3; 
            r_patt2_en <= '0';
          else 
            STATE <= PATT2;
            r_patt2_en <= '1';
          end if;
        
        when PATT3 => 
          if r_change_pattern = '1' then 
            STATE <= PATT4;  
            r_patt3_en <= '0';
          else 
            STATE <= PATT3;
            r_patt3_en <= '1';
          end if;
        
        when PATT4 => 
          if r_change_pattern = '1' then 
            STATE <= PATT1; 
            r_patt4_en <= '0';
          else 
            STATE <= PATT4;
            r_patt4_en <= '1';
          end if;
        
      end case;
    end if;
  end process;
  
  PATT_DECODE_PROC : process(i_clk)
    variable r_patt_en : std_logic_vector(3 downto 0);
  begin
    if rising_edge(i_clk) then 
      r_patt_en := r_patt1_en & r_patt2_en & r_patt3_en & r_patt4_en;
      
      if r_patt_en = "1000" then  -- blink LEDS in circle
        case r_patt1_alt_cntr is 
          when 0 => 
            r_LEDs <= "00001";
          when 1 => 
            r_LEDs <= "00010";
          when 2 => 
            r_LEDs <= "00100";
          when 3 => 
            r_LEDs <= "01000";
        end case;
        
      elsif r_patt_en = "0100" then  -- toggle switch opposite LEDS
        case r_patt2_alt_cntr is 
          when 0 => 
            r_LEDs <= "10101";
          when 1 => 
            r_LEDs <= "11010";
        end case; 
         
      elsif r_patt_en = "0010" then  -- heart beat LEDS
        case r_patt3_alt_cntr is 
          when 0 => 
            r_LEDs <= "00000";
          when 1 => 
            r_LEDs <= "00000";
          when 2 => 
            r_LEDs <= "11111";
          when 3 => 
            r_LEDs <= "00000";
          when 4 => 
            r_LEDs <= "11111";
          when 5 => 
            r_LEDs <= "00000";
        end case; 
        
      elsif r_patt_en = "0001" then -- PWM LEDs
        if r_patt4_cntr <= r_patt4_alt_cntr then 
          r_LEDs <= "11111";
        else 
          r_LEDs <= "00000";
        end if;
                            
      end if;
    end if;
  end process;
  
  -- output assignment
  o_LEDs <= r_LEDs;
  
end architecture;
    
    
