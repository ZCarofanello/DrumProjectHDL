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

ENTITY ADSR IS
    PORT(
        clk                         :IN  STD_LOGIC;
        reset_n                     :IN  STD_LOGIC;
        data_req                    :IN  STD_LOGIC;
		trig_sig					:IN  STD_LOGIC;
		timer_sig					:IN  STD_LOGIC;
        current_state               :OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        );
END ADSR;

ARCHITECTURE rtl OF ADSR IS

BEGIN
 
END ARCHITECTURE rtl;
