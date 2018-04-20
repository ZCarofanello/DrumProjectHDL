--*************************** VHDL Source Code ******************************
--***************************  Copyright 2018  ******************************
--***************************************************************************
--
-- DESIGNER NAME: Zachary Carofanello
--
--
-- FILE NAME: FM_Mod.vhd
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
-- REVisION HisTORY
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

entity FM_Mod is
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
end entity FM_Mod;

architecture rtl of FM_Mod is

signal audio2ADSR :std_logic_vector(15 downto 0);


component SineRom is
  port (
    clk                 : in  std_logic;
    reset_n             : in  std_logic;
    Dat_Req             : in  std_logic;
    i_Frequency         : in  std_logic_vector(15 downto 0);
    Modulation_Dat      : in  std_logic_vector(15 downto 0);
    SineOut             : out std_logic_vector(15 downto 0)
);
end component SineRom;

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

begin

SineRom_inst : SineRom Port Map
( clk            => clk,
  reset_n        => reset_n,
  Dat_Req        => Data_Req,
  i_Frequency    => Pitch,
  Modulation_Dat => Modulation_Dat,
  SineOut        => audio2ADSR
);

ADSR_inst : ADSR port map
(
clk       => clk,
reset_n   => reset_n,
data_req  => Data_Req,
trigger   => Trigger,
Att_M     => Att_M,
Att_D     => Att_D,
Dec_M     => Dec_M,
Dec_D     => Dec_D,
Sus_D     => Sus_D,
Rel_M     => Rel_M,
Rel_D     => Rel_D,
Audio_in  => audio2ADSR,
Audio_out => Audio_out
);

end architecture rtl;
