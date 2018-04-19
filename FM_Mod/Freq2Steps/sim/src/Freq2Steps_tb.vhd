-------------------------------------------------------------------------------
-- Dr. Kaputa
-- seven segment test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Freq2Steps_tb is
end Freq2Steps_tb;

architecture arch of Freq2Steps_tb is

COMPONENT Freq2Steps IS
  port (
    i_clk                 : in  std_logic;
    i_reset_n             : in  std_logic;
    i_Frequency           : in  std_logic_vector(15 downto 0);
    o_Steps               : out std_logic_vector(15 downto 0)
);
end component; 

constant period        : time := 20ns;                                              
signal clk             : std_logic := '0';
signal reset           : std_logic := '0';
signal i_Frequency_tb  : std_logic_vector(15 downto 0) := (OTHERS => '0');

begin
-- bcd iteration
Test_Cases : process 
    begin
        wait  for 4 * period;
        --Input
        i_Frequency_tb <= STD_LOGIC_VECTOR(to_unsigned(1000,16));
        wait  for 4 * period;
        --Input
        i_Frequency_tb <= STD_LOGIC_VECTOR(to_unsigned(2500,16));
        wait  for 4 * period;
        --Input        
        i_Frequency_tb <= STD_LOGIC_VECTOR(to_unsigned(10000,16));
        wait  for 4 * period;
      wait;
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

uut: Freq2Steps  
  port map(        
    i_clk          => clk,
    i_reset_n      => reset,
    i_Frequency    => i_Frequency_tb,
    o_Steps        => open
  );
end arch;