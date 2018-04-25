--*************************** VHDL Source Code ******************************
--***************************  Copyright 2018  ******************************
--***************************************************************************
--
-- DESIGNER NAME: Zachary Carofanello
--
--
-- FILE NAME: Generic_Counter.vhd
--
-------------------------------------------------------------------------------
--
-- DESCRIPTION
--
--    
-- 
-- 
--
-------------------------------------------------------------------------------
--
-- REVISION HISTORY
--
-- _______________________________________________________________________
-- |   DATE   |  USER   | Ver | Description |
-- |==========+=========+=====+=============+==============================
-- |          |         |     |             |
-- | 04/13/18 | ZXC5408 | 1.0 | Created     |
-- |
--
--***************************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity generic_counter is
  port (
    clk             : in  std_logic; 
    reset_n         : in  std_logic;
	enable			: in  std_logic;
	max_count       : in  std_logic_vector(15 downto 0);
    output          : out std_logic
  );  
end generic_counter;  

architecture beh of generic_counter  is

signal count_sig    : std_logic_vector(15 downto 0):= (others => '0');
signal output_int   :std_logic:='0';

begin
process(clk,reset_n)
  begin
    if (reset_n = '0') then 
      count_sig <= (others => '0');
    elsif (clk'event and clk = '1') then
        if (count_sig = max_count) then
            count_sig <= (others => '0');
        elsif(enable = '1') then
            count_sig <= count_sig + 1;
        end if; 
    end if;
  end process;

output_proc:process(clk,reset_n,count_sig,max_count,output_int)
begin
     if (reset_n = '0') then 
        output <= '0';
     elsif (clk'event and clk = '1') then
        output <= '0';
        if (count_sig = max_count) then
           output <= '1';
        else
           output <= '0';
        end if;
    end if;
end process;
--output <= output_int;

end beh;
