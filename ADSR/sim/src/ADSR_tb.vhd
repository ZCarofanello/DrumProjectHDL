-------------------------------------------------------------------------------
-- Dr. Kaputa
-- seven segment test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADSR_tb is
end ADSR_tb;

architecture arch of ADSR_tb is

component ADSR is
    PORT(
        -- Ctrl Signals
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        data_req  : in  std_logic;
        trigger   : in  std_logic;
        -- ADSR Settings
        Att_M     : in  std_logic_vector(15 downto 0);
        Att_D     : in  std_logic_vector(15 downto 0);
        Dec_M     : in  std_logic_vector(15 downto 0);
        Dec_D     : in  std_logic_vector(15 downto 0);
        Sus_D     : in  std_logic_vector(15 downto 0);
        Rel_M     : in  std_logic_vector(15 downto 0);
        Rel_D     : in  std_logic_vector(15 downto 0);
        -- Data Signals
        Audio_in  : in  std_logic_vector(15 downto 0);
        Audio_out : out std_logic_vector(15 downto 0)
        );
end component ADSR;

constant period           : time := 20ns;
constant SamplePeriod     : time := 500ns;
signal trigger_tb       : std_logic := '0';
signal clk                : std_logic := '0';
signal reset              : std_logic := '0';
signal Dat_Req_tb         : std_logic := '0';
signal audio_in_tb        : std_logic_vector(15 downto 0) := X"0150";
signal Att_M_tb           : std_logic_vector(15 downto 0) := X"00FF";
signal Att_D_tb           : std_logic_vector(15 downto 0) := X"0010";
signal Dec_M_tb           : std_logic_vector(15 downto 0) := X"80ff";
signal Dec_D_tb           : std_logic_vector(15 downto 0) := X"0008";
signal Sus_D_tb           : std_logic_vector(15 downto 0) := X"0150";
signal Rel_M_tb           : std_logic_vector(15 downto 0) := X"80FF";
signal Rel_D_tb           : std_logic_vector(15 downto 0) := X"0150";

begin
-- bcd iteration
Test_Cases : process 
    begin
      wait;
  end process; 

-- sample clock process
Sampleclock: process
  begin
    Dat_Req_tb <= not Dat_Req_tb;
    wait for period;
    Dat_Req_tb <= not Dat_Req_tb;
    wait for SamplePeriod/2;
end process; 

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process;

-- trigger process
trigger_proc: process
  begin
    trigger_tb <= not trigger_tb;
    wait for 3us;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '1';
    wait;
end process; 

uut: ADSR  
  port map(  
     clk       => clk,
     reset_n   => reset,
     data_req  => Dat_Req_tb,
     trigger   => trigger_tb,
     -- ADSR   
     Att_M     =>  Att_M_tb,
     Att_D     =>  Att_D_tb,
     Dec_M     =>  Dec_M_tb,
     Dec_D     =>  Dec_D_tb,
     Sus_D     =>  Sus_D_tb,
     Rel_M     =>  Rel_M_tb,
     Rel_D     =>  Rel_D_tb,
     -- Data   
     Audio_in  => audio_in_tb,
     Audio_out => open
  );
end arch;