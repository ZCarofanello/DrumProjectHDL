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
-- This is the FSM for the ADSR component. It looks for the trigger to be
-- pressed to change from ready to attack and each state progresses with the 
-- counter signal except for the sustain state which waits for the trigger to 
-- be released.
--
-------------------------------------------------------------------------------
-- TO DO
-- *Add more comments to FSM
--
--
-------------------------------------------------------------------------------
-- REVISION HISTORY
--
-- _______________________________________________________________________
-- |   DATE   |  USER   | Ver | Description |
-- |==========+=========+=====+=============+==============================
-- |          |         |     |             |
-- | 04/13/18 | ZXC5408 | 1.0 | Created     |
-- | 04/25/18 | ZXC5408 | 1.1 | Added Documentation
--
--***************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FSM_ADSR is
    PORT(
        clk           :IN  std_logic;
        reset_n       :IN  std_logic;
        data_req      :IN  std_logic;
        trig_sig      :IN  std_logic;
        timer_sig     :IN  std_logic;
		change_state  :OUT std_logic;
        current_state :OUT std_logic_vector(4 DOWNTO 0)
        );
END FSM_ADSR;

ARCHITECTURE Behave OF FSM_ADSR is
-- constant declarations
constant reset_s    :std_logic_vector(4 downto 0):= "00000";
constant ready_s    :std_logic_vector(4 downto 0):= "00001";
constant attack_s   :std_logic_vector(4 downto 0):= "00010";
constant decay_s    :std_logic_vector(4 downto 0):= "00100";
constant sustain_s  :std_logic_vector(4 downto 0):= "01000";
constant release_s  :std_logic_vector(4 downto 0):= "10000";

-- signal declarations
signal current_state_int, current_state_z  : std_logic_vector(4 downto 0);
signal next_state         : std_logic_vector(4 downto 0);
signal change_state_int	  : std_logic;

BEGIN   
    current_state <= current_state_int;

    Sync:PROCESS(clk, reset_n) is
    BEGIN
        IF(reset_n = '0') THEN
            current_state_int <= reset_s;
        ELSIF(clk'EVENT AND clk = '1') THEN
            current_state_int <= next_state;
        END IF;
    END PROCESS;
	
	ChangeState_proc:process(clk,reset_n,current_state_int,next_state)
	begin
		if(reset_n = '0') then
			change_state_int <= '1';
            current_state_z <= reset_s;
		elsif(clk'event and clk = '0') then
			if(current_state_int /= current_state_z) then
				change_state_int <= '1';
                current_state_z <= current_state_int;
			else 
				change_state_int <= '0';
			end if;
		end if;
	end process;
	
	change_state <= change_state_int;
        
    ZeCloud:PROCESS(current_state_int, next_state, data_req, timer_sig, trig_sig) is
    BEGIN
        CASE (current_state_int) is
            WHEN reset_s =>
                next_state <= ready_s;
            WHEN ready_s =>
                if(trig_sig = '1') then
                    next_state <= attack_s;
                else
                    next_state <= ready_s;
                end if;
            WHEN attack_s =>
          if(timer_sig = '1') then
          next_state <= decay_s;
          else
                next_state <= attack_s;
          end if;
            WHEN decay_s =>
          if(timer_sig = '1') then
          next_state <= sustain_s;
          else
                next_state <= decay_s;
          end if;
            WHEN sustain_s =>
          if(trig_sig = '0') then
          next_state <= release_s;
          else
                next_state <= sustain_s;
          end if;
            WHEN release_s =>
          if(timer_sig = '1') then
          next_state <= ready_s;
          else
                next_state <= release_s;
          end if;
            WHEN OTHERS =>
                next_state <= reset_s;
        END CASE;
    END PROCESS;
    
END Behave;
