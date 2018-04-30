-------------------------------------------------------------------------------
-- Dr. Kaputa
-- seven segment test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FM_Mod_tb is
end FM_Mod_tb;

architecture arch of FM_Mod_tb is

component FM_Mod IS
  port (
    --Ctrl Signals
    clk                 : in  std_logic;
    reset_n             : in  std_logic;
    Data_Req            : in  std_logic;
    Trigger             : in  std_logic;
    -- Data Inputs
    Pitch               : in  std_logic_vector(15 downto 0);
    Modulation_Dat      : in  std_logic_vector(15 downto 0);
    --ADSR Settings
    Att_M               : in  std_logic_vector(15 downto 0);
    Att_D               : in  std_logic_vector(15 downto 0);
    Dec_M               : in  std_logic_vector(15 downto 0);
    Dec_D               : in  std_logic_vector(15 downto 0);
    Sus_D               : in  std_logic_vector(15 downto 0);
    Rel_M               : in  std_logic_vector(15 downto 0);
    Rel_D               : in  std_logic_vector(15 downto 0);
    --Audio Output
    Audio_out           : out std_logic_vector(15 downto 0)
);
end component FM_Mod;

constant period           : time := 20ns;
constant SamplePeriod     : time := 20us;
signal trigger_tb          : std_logic := '0';
signal clk                : std_logic := '0';
signal reset              : std_logic := '0';
signal Dat_Req_tb         : std_logic := '0';
signal i_Frequency_tb     : std_logic_vector(15 downto 0) := X"03E8";
signal Modulation_Dat_tb  : std_logic_vector(15 downto 0) := (OTHERS => '0');
signal Att_M_tb           : std_logic_vector(15 downto 0) := X"000A";
signal Att_D_tb           : std_logic_vector(15 downto 0) := X"00FF";
signal Dec_M_tb           : std_logic_vector(15 downto 0) := X"0005";
signal Dec_D_tb           : std_logic_vector(15 downto 0) := X"00F0";
signal Sus_D_tb           : std_logic_vector(15 downto 0) := X"0150";
signal Rel_M_tb           : std_logic_vector(15 downto 0) := X"0005";
signal Rel_D_tb           : std_logic_vector(15 downto 0) := X"008E";

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
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '1';
    wait;
end process;

-- trigger process
trigger_proc: process
  begin
    trigger_tb <= not trigger_tb;
    wait for 50ms;
end process;  

uut: FM_Mod  
  port map(  
     clk             => clk,
     reset_n         => reset,
     Data_Req        => Dat_Req_tb,
     Trigger         => trigger_tb,
     -- Data Inputs  
     Pitch           => i_Frequency_tb,
     Modulation_Dat  => Modulation_Dat_tb,
     --ADSR Setting  
     Att_M           => Att_M_tb,
     Att_D           => Att_D_tb,
     Dec_M           => Dec_M_tb,
     Dec_D           => Dec_D_tb,
     Sus_D           => Sus_D_tb,
     Rel_M           => Rel_M_tb,
     Rel_D           => Rel_D_tb,
     --Audio Output
     Audio_out       => open
  );
end arch;