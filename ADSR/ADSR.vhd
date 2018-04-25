--*************************** VHDL Source Code ******************************
--***************************  Copyright 2018  ******************************
--***************************************************************************
--
-- DESIGNER NAME: Zachary Carofanello
--
--
-- FILE NAME: ADSR.vhd
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

ENTITY ADSR is
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
END ADSR;

ARCHITECTURE rtl OF ADSR is

component FSM_ADSR is
    PORT(
        clk           :IN  std_logic;
        reset_n       :IN  std_logic;
        data_req      :IN  std_logic;
        trig_sig      :IN  std_logic;
        timer_sig     :IN  std_logic;
		change_state  :OUT std_logic;
        current_state :OUT std_logic_vector(4 DOWNTO 0)
        );
END component FSM_ADSR;

component generic_counter is
  port (
    clk             : in  std_logic; 
    reset_n         : in  std_logic;
	enable			: in  std_logic;
	max_count       : in  std_logic_vector(15 downto 0);
    output          : out std_logic
  );  
end component generic_counter;

component mult is
  port (
	dataa			: in  std_logic_vector(15 downto 0);
	datab           : in  std_logic_vector(15 downto 0);
    result          : out std_logic_vector(31 downto 0)
  );  
end component mult;  

signal CounterReset, change_state,Cnt_Flag :std_logic:= '0';
signal Max_Cnt_int,audio_mult_out  :std_logic_vector(15 downto 0);
signal current_slope_int, current_slope_inc :std_logic_vector(15 downto 0);
signal audio_mult_out_full :std_logic_vector(31 downto 0):=(others => '0');
signal state :std_logic_vector(4 downto 0):=(others => '0');
BEGIN

FSM_ADSR_inst: FSM_ADSR
port map(
clk           => clk,
reset_n       => reset_n,
data_req      => data_req,
trig_sig      => trigger,
timer_sig     => Cnt_Flag,
change_state  => change_state,
current_state => state
);


duration_proc: process(reset_n, clk,Att_D,Dec_D,Sus_D,Rel_D)
begin
		case state is
			when "00000" => Max_Cnt_int <= (others => '1');
			when "00001" => Max_Cnt_int <= (others => '1');
			when "00010" => Max_Cnt_int <= Att_D;
			when "00100" => Max_Cnt_int <= Dec_D;
			when "01000" => Max_Cnt_int <= Sus_D;
			when "10000" => Max_Cnt_int <= Rel_D;
			when others  => Max_Cnt_int <= (others => '1');
		end case;
end process;

slope_proc: process(current_slope_inc, state, Att_M,Dec_M,Rel_M)
begin
	case state is
		when "00000" => current_slope_inc <= (others => '0');
		when "00001" => current_slope_inc <= (others => '0');
		when "00010" => current_slope_inc <= Att_M;
		when "00100" => current_slope_inc <= Dec_M;
		when "01000" => current_slope_inc <= (others => '0');
		when "10000" => current_slope_inc <= Rel_M;
		when others  => current_slope_inc <= (others => '0');
	end case;
end process;
	
slope_calc_proc: process(clk, reset_n,data_req, current_slope_inc,current_slope_int)
begin
    IF(reset_n = '0') THEN
        current_slope_int <= (others => '0');
    ELSIF(clk'EVENT AND clk = '1') THEN
		case state is
			when "00000" => current_slope_int <= (others => '0');
			when "00001" => current_slope_int <= (others => '0');
			when "00010" => 
				if((current_slope_int + current_slope_inc) >= X"7FF0") then
					current_slope_int <= (others => '1');
				else
					current_slope_int <= current_slope_int + current_slope_inc;
				end if;
			when "00100" => 
			    if((current_slope_int - current_slope_inc) <= X"0000") then
					current_slope_int <= (others => '0');
				else
					current_slope_int <= current_slope_int - current_slope_inc;
				end if;
			when "01000" => current_slope_int <= current_slope_int;
			when "10000" =>
				if((current_slope_int - current_slope_inc) <= X"0000") then
					current_slope_int <= (others => '0');
				else
					current_slope_int <= current_slope_int - current_slope_inc;
				end if;
			when others  => current_slope_int <= (others => '0');
		end case;
    END IF;
end process;

mult_inst:mult
port map(
dataa  => Audio_in,
datab  => current_slope_int,
result => audio_mult_out_full
);
audio_mult_out <= audio_mult_out_full(31 downto 16);

CounterReset <= reset_n ;
counter_inst: generic_counter
port map(
clk         => clk,
reset_n     => CounterReset,
enable	    => data_req,
max_count   => Max_Cnt_int,
output      => Cnt_Flag
);

 Audio_out <= audio_mult_out;
 
END ARCHITECTURE rtl;
