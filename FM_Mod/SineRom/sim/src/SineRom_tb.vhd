-------------------------------------------------------------------------------
-- Dr. Kaputa
-- seven segment test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SineRom_tb is
end SineRom_tb;

architecture arch of SineRom_tb is

component SineRom IS
  port (
    clk                 : in  std_logic;
    reset_n             : in  std_logic;
    Dat_Req             : in  std_logic;
    i_Frequency         : in  std_logic_vector(15 downto 0);
    Modulation_Dat      : in  std_logic_vector(15 downto 0);
    SineOut             : out std_logic_vector(15 downto 0)
);
end component SineRom;

constant period           : time := 20ns;
constant SamplePeriod     : time := 1us;
signal clk                : std_logic := '0';
signal reset              : std_logic := '0';
signal Dat_Req_tb         : std_logic := '0';
signal i_Frequency_tb     : std_logic_vector(15 downto 0) := X"03e8";
signal Modulation_Dat_tb  : std_logic_vector(15 downto 0) := (OTHERS => '0');

begin
-- bcd iteration
Test_Cases : process 
    begin
      wait;
  end process; 

-- sample clock process
clock: process
  begin
    Dat_Req_tb <= not Dat_Req_tb;
    wait for period;
    Dat_Req_tb <= not Dat_Req_tb;
    wait for SamplePeriod/2;
end process; 

-- clock process
Sampleclock: process
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

uut: SineRom  
  port map(  
    clk             => clk,
    reset_n         => reset,
    Dat_Req         => Dat_Req_tb,
    i_Frequency     => i_Frequency_tb,
    Modulation_Dat  => Modulation_Dat_tb,
    SineOut         => open
  );
end arch;