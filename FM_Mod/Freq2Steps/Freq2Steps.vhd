
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Freq2Steps is
  port (
    i_clk       : in  std_logic:='0';
    i_reset_n   : in  std_logic:='1';
    i_Frequency : in  std_logic_vector(15 downto 0):=(others=>'0');
    o_Steps     : out std_logic_vector(15 downto 0):=(others=>'0')
);
end Freq2Steps;

architecture rtl of Freq2Steps is

component Freq2StepsMult IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
	);
END component Freq2StepsMult;

signal Mult_Out_Full   :std_logic_vector(63 downto 0):=(others=>'0');
signal Mult_Out_Concat :std_logic_vector(15 downto 0):=(others=>'0');
signal Freq_In_Ext     :std_logic_vector(31 downto 0):=(others=>'0');

begin

Freq_In_ext <= i_Frequency & "0000000000000000";

    Freq2StepsMult_inst : Freq2StepsMult PORT MAP (
		clock	 => i_clk,
		dataa	 => Freq_In_Ext,
		result	 => Mult_Out_Full
	);
    
    o_Steps <= Mult_Out_Full(46 downto 31);
 
end architecture rtl;