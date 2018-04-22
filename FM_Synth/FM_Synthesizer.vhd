--*************************** VHDL Source Code ******************************
--***************************  Copyright 2018  ******************************
--***************************************************************************
--
-- DESIGNER NAME: Zachary Carofanello
--
--
-- FILE NAME: FM_Synthesizer.vhd
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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_signed.all;

entity FM_Synthesizer is
  port (
    clk              : in  std_logic                     := '0';             --  clock.clk
    reset_n          : in  std_logic                     := '0';             --  reset.reset_n
    addressess       : in  std_logic_vector(7 downto 0)  := (others => '0'); --  avs_s0_addressess
    write_n          : in  std_logic                     := '0';             --  write_n
    writedata        : in  std_logic_vector(31 downto 0) := (others => '0'); --  writedata
    byteenable_n     : in  std_logic_vector(3 downto 0)  := (others => '0'); --  byteenable_n
    readdata         : out std_logic_vector(31 downto 0)                     --  readdata
  );
end entity FM_Synthesizer;

ARCHITECTURE rtl OF FM_Synthesizer IS

--Component Declarations
component avalon_MM_slave_interface IS
  PORT (
    clk           : IN  std_logic;
    reset_n       : IN  std_logic;
    we_n          : IN  std_logic;
    addr          : IN  std_logic_vector(7  DOWNTO 0);
    byteenable_n  : IN  std_logic_vector(3  DOWNTO 0);
    din           : IN  std_logic_vector(31 DOWNTO 0);
    dout          : OUT std_logic_vector(31 DOWNTO 0);
    --Internal Connections
    
    --Control Signals
    Data_Req            : out std_logic;
    Trigger             : out std_logic;
	Alg_Select			: out std_logic_vector(15 downto 0);
    
    --Data Signals
    Audio_Dat           : in  std_logic_vector(15 downto 0);
    New_Dat             : in  std_logic;
    
    --Operator 1 Settings
    Op1_Frequency       : out std_logic_vector(15 downto 0);
    Op1_Feedback        : out std_logic_vector(15 downto 0);
    Op1_Att_M           : out std_logic_vector(15 downto 0);
    Op1_Att_D           : out std_logic_vector(15 downto 0);
    Op1_Dec_M           : out std_logic_vector(15 downto 0);
    Op1_Dec_D           : out std_logic_vector(15 downto 0);
    Op1_Sus_D           : out std_logic_vector(15 downto 0);
    Op1_Rel_M           : out std_logic_vector(15 downto 0);
    Op1_Rel_D           : out std_logic_vector(15 downto 0);
    
    --Operator 2 Settings
    Op2_Frequency       : out std_logic_vector(15 downto 0);
    Op2_Feedback        : out std_logic_vector(15 downto 0);
    Op2_Att_M           : out std_logic_vector(15 downto 0);
    Op2_Att_D           : out std_logic_vector(15 downto 0);
    Op2_Dec_M           : out std_logic_vector(15 downto 0);
    Op2_Dec_D           : out std_logic_vector(15 downto 0);
    Op2_Sus_D           : out std_logic_vector(15 downto 0);
    Op2_Rel_M           : out std_logic_vector(15 downto 0);
    Op2_Rel_D           : out std_logic_vector(15 downto 0);
    
    --Operator 3 Settings
    Op3_Frequency       : out std_logic_vector(15 downto 0);
    Op3_Feedback        : out std_logic_vector(15 downto 0);
    Op3_Att_M           : out std_logic_vector(15 downto 0);
    Op3_Att_D           : out std_logic_vector(15 downto 0);
    Op3_Dec_M           : out std_logic_vector(15 downto 0);
    Op3_Dec_D           : out std_logic_vector(15 downto 0);
    Op3_Sus_D           : out std_logic_vector(15 downto 0);
    Op3_Rel_M           : out std_logic_vector(15 downto 0);
    Op3_Rel_D           : out std_logic_vector(15 downto 0);
    
    --Operator 4 Settings
    Op4_Frequency       : out std_logic_vector(15 downto 0);
    Op4_Feedback        : out std_logic_vector(15 downto 0);
    Op4_Att_M           : out std_logic_vector(15 downto 0);
    Op4_Att_D           : out std_logic_vector(15 downto 0);
    Op4_Dec_M           : out std_logic_vector(15 downto 0);
    Op4_Dec_D           : out std_logic_vector(15 downto 0);
    Op4_Sus_D           : out std_logic_vector(15 downto 0);
    Op4_Rel_M           : out std_logic_vector(15 downto 0);
    Op4_Rel_D           : out std_logic_vector(15 downto 0)
);
end component avalon_MM_slave_interface;

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

-- Signal Declarations
signal Operator1_Data, Operator2_Data :std_logic_vector(15 downto 0);
signal Operator3_Data, Operator4_Data :std_logic_vector(15 downto 0);
signal data_req_int, trig_int :std_logic;

--Operator 1 Signals
  signal Op1_Mod_Data	   :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Frequency_int :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Feedback_int  :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Att_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Att_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Dec_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Dec_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Sus_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Rel_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op1_Rel_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  
  --Operator 2 Signals
  signal Op2_Mod_Data	   :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Frequency_int :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Feedback_int  :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Att_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Att_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Dec_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Dec_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Sus_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Rel_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op2_Rel_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  
  --Operator 3 Signals
  signal Op3_Mod_Data	   :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Frequency_int :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Feedback_int  :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Att_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Att_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Dec_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Dec_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Sus_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Rel_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op3_Rel_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  
  --Operator 4 Signals
  signal Op4_Mod_Data	   :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Frequency_int :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Feedback_int  :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Att_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Att_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Dec_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Dec_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Sus_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Rel_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Rel_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  
  signal Audio_Out 		   :std_logic_vector(15 downto 0):= (others => '0');
  signal alg_select_int    :std_logic_vector(15 downto 0):= (others => '0');

BEGIN

Alg_out_proc:process(clk,reset_n,Operator1_Data,Operator2_Data,Operator2_Data,Operator4_Data,alg_select_int)
begin
	case alg_select_int is
		when X"0000" => Audio_Out <= Operator1_Data;
		when X"0001" => Audio_Out <= Operator1_Data;
		when X"0002" => Audio_Out <= Operator1_Data;
		when X"0003" => Audio_Out <= Operator1_Data;
		when X"0004" => Audio_Out <= Operator1_Data + Operator3_Data;
		when X"0005" => Audio_Out <= Operator1_Data + Operator2_Data + Operator3_Data;
		when X"0006" => Audio_Out <= Operator1_Data + Operator2_Data + Operator3_Data;
		when X"0007" => Audio_Out <= Operator1_Data + Operator2_Data + Operator3_Data + Operator4_Data;
		when others  => Audio_Out <= (others => '0');
	end case;

end process;


Op1_Mod_Dat_proc:process(clk,reset_n,Operator1_Data,Operator2_Data,Operator2_Data,Operator4_Data,alg_select_int)
begin
	case alg_select_int is
		when X"0000" => Op1_Mod_Data <= X"0000";
		when X"0001" => Op1_Mod_Data <= Operator2_Data;
		when X"0002" => Op1_Mod_Data <= Operator2_Data + Operator4_Data;
		when X"0003" => Op1_Mod_Data <= Operator2_Data + Operator3_Data;
		when X"0004" => Op1_Mod_Data <= Operator2_Data;
		when X"0005" => Op1_Mod_Data <= Operator4_Data;
		when X"0006" => Op1_Mod_Data <= X"0000";
		when X"0007" => Op1_Mod_Data <= X"0000";
		when others  => Op1_Mod_Data <=(others => '0');
	end case;

end process;

Op2_Mod_Dat_proc:process(clk,reset_n,Operator1_Data,Operator2_Data,Operator2_Data,Operator4_Data,alg_select_int)
begin
	case alg_select_int is
		when X"0000" => Op2_Mod_Data <= Operator3_Data;
		when X"0001" => Op2_Mod_Data <= Operator3_Data + Operator4_Data;
		when X"0002" => Op2_Mod_Data <= Operator3_Data;
		when X"0003" => Op2_Mod_Data <= X"0000";
		when X"0004" => Op2_Mod_Data <= X"0000";
		when X"0005" => Op2_Mod_Data <= Operator4_Data;
		when X"0006" => Op2_Mod_Data <= X"0000";
		when X"0007" => Op2_Mod_Data <= X"0000";
		when others  => Op2_Mod_Data <=(others => '0');
	end case;

end process;

Op3_Mod_Dat_proc:process(clk,reset_n,Operator1_Data,Operator2_Data,Operator2_Data,Operator4_Data,alg_select_int)
begin
	case alg_select_int is
		when X"0000" => Op3_Mod_Data <= Operator4_Data;
		when X"0001" => Op3_Mod_Data <= X"0000";
		when X"0002" => Op3_Mod_Data <= X"0000";
		when X"0003" => Op3_Mod_Data <= Operator4_Data;
		when X"0004" => Op3_Mod_Data <= Operator4_Data;
		when X"0005" => Op3_Mod_Data <= Operator4_Data;
		when X"0006" => Op3_Mod_Data <= Operator4_Data;
		when X"0007" => Op3_Mod_Data <= X"0000";
		when others  => Op3_Mod_Data <=(others => '0');
	end case;

end process;

Operator1 : FM_Mod 
port map(
    clk            => clk,
    reset_n        => reset_n,
    Data_Req       => data_req_int,
    Trigger        => trig_int,
    Pitch          => Op1_Frequency_int,
    Modulation_Dat => Op1_Mod_Data,
    Att_M          => Op1_Att_M_int,
    Att_D          => Op1_Att_D_int,
    Dec_M          => Op1_Dec_M_int,
    Dec_D          => Op1_Dec_D_int,
    Sus_D          => Op1_Sus_D_int,
    Rel_M          => Op1_Rel_M_int,
    Rel_D          => Op1_Rel_D_int,
    Audio_out      => Operator1_Data
);

Operator2 : FM_Mod 
port map(
    clk            => clk,
    reset_n        => reset_n,
    Data_Req       => data_req_int,
    Trigger        => trig_int,
    Pitch          => Op2_Frequency_int,
    Modulation_Dat => Op2_Mod_Data,
    Att_M          => Op2_Att_M_int,
    Att_D          => Op2_Att_D_int,
    Dec_M          => Op2_Dec_M_int,
    Dec_D          => Op2_Dec_D_int,
    Sus_D          => Op2_Sus_D_int,
    Rel_M          => Op2_Rel_M_int,
    Rel_D          => Op2_Rel_D_int,
    Audio_out      => Operator2_Data
);

Operator3 : FM_Mod 
port map(
    clk            => clk,
    reset_n        => reset_n,
    Data_Req       => data_req_int,
    Trigger        => trig_int,
    Pitch          => Op3_Frequency_int,
    Modulation_Dat => Op3_Mod_Data,
    Att_M          => Op3_Att_M_int,
    Att_D          => Op3_Att_D_int,
    Dec_M          => Op3_Dec_M_int,
    Dec_D          => Op3_Dec_D_int,
    Sus_D          => Op3_Sus_D_int,
    Rel_M          => Op3_Rel_M_int,
    Rel_D          => Op3_Rel_D_int,
    Audio_out      => Operator3_Data
);

Operator4 : FM_Mod 
port map(
    clk            => clk,
    reset_n        => reset_n,
    Data_Req       => data_req_int,
    Trigger        => trig_int,
    Pitch          => Op4_Frequency_int,
    Modulation_Dat => X"0000",
    Att_M          => Op4_Att_M_int,
    Att_D          => Op4_Att_D_int,
    Dec_M          => Op4_Dec_M_int,
    Dec_D          => Op4_Dec_D_int,
    Sus_D          => Op4_Sus_D_int,
    Rel_M          => Op4_Rel_M_int,
    Rel_D          => Op4_Rel_D_int,
    Audio_out      => Operator4_Data
);

avalon_bus:avalon_MM_slave_interface
port map(
clk      => clk,
reset_n    => reset_n,
we_n      => write_n,
addr      => addressess,
byteenable_n => byteenable_n,
din      => writedata,
dout      => readdata,
--Control Sig 
Data_Req      => data_req_int,
Trigger       => trig_int,
Alg_Select	  => alg_select_int,
              
--Data Signal 
Audio_Dat     => Audio_Out,
New_Dat       => '1',
              
--Operator 1  
Op1_Frequency => Op1_Frequency_int,
Op1_Feedback  => Op1_Feedback_int,
Op1_Att_M     => Op1_Att_M_int,
Op1_Att_D     => Op1_Att_D_int,    
Op1_Dec_M     => Op1_Dec_M_int,    
Op1_Dec_D     => Op1_Dec_D_int,    
Op1_Sus_D     => Op1_Sus_D_int,    
Op1_Rel_M     => Op1_Rel_M_int,    
Op1_Rel_D     => Op1_Rel_D_int,    
              
--Operator 2  
Op2_Frequency => Op2_Frequency_int,
Op2_Feedback  => Op2_Feedback_int,
Op2_Att_M     => Op2_Att_M_int,
Op2_Att_D     => Op2_Att_D_int,    
Op2_Dec_M     => Op2_Dec_M_int,    
Op2_Dec_D     => Op2_Dec_D_int,    
Op2_Sus_D     => Op2_Sus_D_int,    
Op2_Rel_M     => Op2_Rel_M_int,    
Op2_Rel_D     => Op2_Rel_D_int,    
              
--Operator 3  
Op3_Frequency => Op3_Frequency_int,
Op3_Feedback  => Op3_Feedback_int,
Op3_Att_M     => Op3_Att_M_int,
Op3_Att_D     => Op3_Att_D_int,    
Op3_Dec_M     => Op3_Dec_M_int,    
Op3_Dec_D     => Op3_Dec_D_int,    
Op3_Sus_D     => Op3_Sus_D_int,    
Op3_Rel_M     => Op3_Rel_M_int,    
Op3_Rel_D     => Op3_Rel_D_int,    
              
--Operator 4  
Op4_Frequency => Op4_Frequency_int,
Op4_Feedback  => Op4_Feedback_int,
Op4_Att_M     => Op4_Att_M_int,
Op4_Att_D     => Op4_Att_D_int,    
Op4_Dec_M     => Op4_Dec_M_int,    
Op4_Dec_D     => Op4_Dec_D_int,    
Op4_Sus_D     => Op4_Sus_D_int,    
Op4_Rel_M     => Op4_Rel_M_int,    
Op4_Rel_D     => Op4_Rel_D_int 
);
 
END ARCHITECTURE rtl;
