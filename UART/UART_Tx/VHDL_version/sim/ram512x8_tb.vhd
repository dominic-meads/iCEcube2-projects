-- tests the ram512x8 primitive from the memory usage guide
library ieee;
use ieee.std_logic_1164.all;

entity ram512x8_tb is 
end entity;

architecture sim of ram512x8_tb is 

  signal WADDR : std_logic_vector(8 downto 0) := (others => '0');
  signal CLK  : std_logic := '0';
  signal WCLKE : std_logic := '0';
  signal WDATA : std_logic_vector(7 downto 0) := (others => '0');
  signal WE    : std_logic := '0';
  signal RADDR : std_logic_vector(8 downto 0) := (others => '0');
  signal RCLKE : std_logic := '0';
  signal RE    : std_logic := '0';
  signal RDATA : std_logic_vector(7 downto 0);

begin
  
  -- same read and write clock
  ram512x8_inst : entity work.ram512x8(rtl)
    port map ( 
      RDATA => RDATA, 
      RADDR => RADDR, 
      RCLK => CLK,  
      RCLKE => RCLKE, 
      RE => RE, 
      WADDR => WADDR, 
      WCLK=> CLK,
      WCLKE => WCLKE, 
      WDATA => WDATA, 
      WE => WE 
    );

  CLK_PROC : process is 
  begin 
    wait for 41.667 ns;
    CLK <= not CLK;
  end process CLK_PROC;

  STIM_PROC : process is 
  begin
    -- writing something to bram first
    wait for 166.668 ns;
    WADDR <= "000000000";
    WDATA <= x"FF";
    wait for 83.334 ns;
    WE    <= '1';
    WCLKE <= '1'; 
    wait for 83.334 ns;
    WADDR <= "000000001";
    WDATA <= x"EE";
    wait for 83.334 ns;
    WADDR <= "000000010";
    WDATA <= x"AA";
    wait for 83.334 ns;
    WE    <= '0';
    WCLKE <= '0'; 

    -- read the written data
    wait for 166.668 ns;
    RADDR <= "000000000";
    wait for 83.334 ns;
    RE    <= '1';
    RCLKE <= '1'; 
    wait for 83.334 ns;
    RADDR <= "000000001";
    wait for 83.334 ns;
    RADDR <= "000000010";
    wait for 83.334 ns;
    RE    <= '0';
    RCLKE <= '0';

    wait;
  end process STIM_PROC;

  RDATA_RESULT_PROC : process is 
  begin 
    wait until RADDR = "000000000";
    if RDATA = x"FF" then 
      report "FIRST DATA READ CORRECT";
      wait until RADDR = "000000001";
      if RDATA = x"EE" then 
        report "SECOND FIRST DATA READ CORRECT";
        wait until RADDR = "000000001";
        if RDATA = x"EE" then 
          report "3RD DATA READ CORRECT";
          report "ALL TESTS COMPLETE, READ DATA MATCHES ALL WRITTEN DATA";
        else
          report "ERROR: RDATA AT RADDR b000000010 DOES NOT MATCH WRITTEN DATA"; 
        end if;
      else 
        report "ERROR: RDATA AT RADDR b000000001 DOES NOT MATCH WRITTEN DATA"; 
      end if;
    else
      report "ERROR: RDATA AT RADDR b000000000 DOES NOT MATCH WRITTEN DATA";
    end if;
  end process RDATA_RESULT_PROC;

end architecture;