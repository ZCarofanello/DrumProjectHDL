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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

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

BEGIN

 Audio_out <= Audio_in;
 
END ARCHITECTURE rtl;
