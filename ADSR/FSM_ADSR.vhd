--*************************** VHDL Source Code ******************************
--***************************  Copyright 2018  ******************************
--***************************************************************************
--
-- DESIGNER NAME: Zachary Carofanello
--
--
-- FILE NAME: FSM_ADSR.vhd
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

ENTITY FSM_ADSR IS
    PORT(
        clk                         :IN  STD_LOGIC;
        reset_n                     :IN  STD_LOGIC;
        data_req                    :IN  STD_LOGIC;
		trig_sig					:IN  STD_LOGIC;
		timer_sig					:IN  STD_LOGIC;
        current_state               :OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        );
END FSM_ADSR;

ARCHITECTURE Behave OF FSM_ADSR IS
-- constant declarations
constant reset_s    :STD_LOGIC_VECTOR(4 downto 0):= "00000";
constant ready_s    :STD_LOGIC_VECTOR(4 downto 0):= "00001";
constant attack_s   :STD_LOGIC_VECTOR(4 downto 0):= "00010";
constant decay_s    :STD_LOGIC_VECTOR(4 downto 0):= "00100";
constant sustain_s  :STD_LOGIC_VECTOR(4 downto 0):= "01000";
constant release_s  :STD_LOGIC_VECTOR(4 downto 0):= "10000";

-- signal declarations
signal current_state_int  : std_logic_vector(3 downto 0);
signal next_state         : std_logic_vector(3 downto 0);

BEGIN   
    The_Current_State <= current_state_int;

    Sync:PROCESS(clk, reset_n) IS
    BEGIN
        IF(reset_n = '0') THEN
            current_state_int <= reset_s;
        ELSIF(clk'EVENT AND clk = '1') THEN
            current_state_int <= next_state;
        END IF;
    END PROCESS;
        
    ZeCloud:PROCESS(current_state_int, data_req, timer_sig, trig_sig) IS
    BEGIN
        CASE (current_state_int) IS
            WHEN reset_s =>
                next_state <= ready_s;
            WHEN ready_s =>
				if(data_req = '1' and trig_sig = '1') then
					next_state <= attack_s;
				end if;
				next_state <= ready_s;
            WHEN attack_s =>
			    if(timer_sig = '1') then
					next_state <= decay_s;
				end if;
                next_state <= attack_s;
            WHEN decay_s =>
			    if(timer_sig = '1') then
					next_state <= sustain_s;
				end if;
                next_state <= decay_s;       
            WHEN sustain_s =>
			    if(timer_sig = '1') then
					next_state <= release_s;
				end if;
                next_state <= sustain_s;
            WHEN release_s =>
			    if(timer_sig = '1') then
					next_state <= ready_s;
				end if;
                next_state <= release_s;
            WHEN OTHERS =>
                next_state <= reset_s;
        END CASE;
    END PROCESS;
    
END Behave;
