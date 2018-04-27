--*************************** VHDL Source Code ******************************
--***************************  Copyright 2018  ******************************
--***************************************************************************
--
-- DESIGNER NAME: Zachary Carofanello
--
--
-- FILE NAME: avalon_MM_slave_interface.vhd
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
use ieee.numeric_std.ALL;

ENTITY avalon_MM_slave_interface IS
  PORT (
    clk 				: IN  std_logic;
    reset_n 			: IN  std_logic;
    we_n 				: IN  std_logic;
    addr 				: IN  std_logic_vector(7  DOWNTO 0);
	byteenable_n 		: IN  std_logic_vector(3  DOWNTO 0);
    din 				: IN  std_logic_vector(31 DOWNTO 0);
    dout 				: OUT std_logic_vector(31 DOWNTO 0);
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
END ENTITY avalon_MM_slave_interface;

ARCHITECTURE rtl OF avalon_MM_slave_interface IS
  TYPE ram_type IS ARRAY (255 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
  SIGNAL byte_0, byte_1, byte_2, byte_3 : ram_type;
  SIGNAL read_address : std_logic_vector(7 DOWNTO 0);
  
  --Offsets in memory
  constant CTL_OFFSET  :integer := 0;
  constant DAT_OFFSET  :integer := 1;
  constant OP1_OFFSET  :integer := 2;
  constant OP2_OFFSET  :integer := 7;
  constant OP3_OFFSET  :integer := 12;
  constant OP4_OFFSET  :integer := 17;
  
  constant FREQ_OFFSET :integer := 0;
  constant FBCK_OFFSET :integer := 0;
  constant ATT_OFFSET  :integer := 1;
  constant DEC_OFFSET  :integer := 2;
  constant SUS_OFFSET  :integer := 3;
  constant REL_OFFSET  :integer := 4;
    
  --Control Signals
  signal Data_Req_int :std_logic;
  signal Trigger_int  :std_logic;
  signal Alg_Select_int :std_logic_vector(15 downto 0);
  
  --Operator 1 Signals
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
  signal Op4_Frequency_int :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Feedback_int  :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Att_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Att_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Dec_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Dec_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Sus_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Rel_M_int     :std_logic_vector(15 downto 0):= (others => '0');
  signal Op4_Rel_D_int     :std_logic_vector(15 downto 0):= (others => '0');
  
  
  
BEGIN
  RamBlock : PROCESS(clk) BEGIN
    IF (clk'event AND clk = '1') THEN
      IF (reset_n = '0') THEN
        read_address <= (OTHERS => '0');
      ELSIF (we_n = '0') THEN --Processor Writing to Memory
		if(byteenable_n(0) = '0') then
			byte_0(to_integer(unsigned(addr))) <= (din(7  downto  0));
		end if;
		
		if(byteenable_n(1) = '0') then
			byte_1(to_integer(unsigned(addr))) <= (din(15 downto  8));
		end if;
		
		if(byteenable_n(2) = '0') then
			byte_2(to_integer(unsigned(addr))) <= (din(23 downto 16));
		end if;
		
		if(byteenable_n(3) = '0') then
			byte_3(to_integer(unsigned(addr))) <= (din(31 downto 24));
		end if;
      else -- Writing Data from component
        --Ctrl Signals Being Written
        if( byte_1(CTL_OFFSET)(0) = '1') then
            byte_1(CTL_OFFSET)(0) <= '0';
        end if;

        --Data Signals Being Written
        byte_0(DAT_OFFSET) <= Audio_Dat(7  downto 0);
		byte_1(DAT_OFFSET) <= Audio_Dat(15 downto 8);
        byte_2(DAT_OFFSET)(0) <= New_Dat;
        
      END IF;
      read_address <= addr;
    END IF;
  END PROCESS RamBlock;
  
  -- Data back to Processor
  dout(7  downto  0) <= byte_0(to_integer(unsigned(read_address)));
  dout(15 downto  8) <= byte_1(to_integer(unsigned(read_address)));
  dout(23 downto 16) <= byte_2(to_integer(unsigned(read_address)));
  dout(31 downto 24) <= byte_3(to_integer(unsigned(read_address)));
  
    --Control Interface
    Data_Req_proc:process(clk,reset_n,byte_1,Data_Req_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Data_Req_int <= '0';
            else
                Data_Req_int <= byte_1(CTL_OFFSET)(0);
            end if;
        end if;
    end process;
	 
	 Data_Req <= Data_Req_int;
    
    Trigger_proc:process(clk,reset_n,byte_0,Trigger_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Trigger_int <= '0';
            else
                Trigger_int <= byte_0(CTL_OFFSET)(0);
            end if;
        end if;
    end process;
	 
	 Trigger <= Trigger_int;
    
    Alg_Select_Proc:process(clk,reset_n,byte_3,byte_2, Alg_Select_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Alg_Select_int <= (others=>'1');
            else
                Alg_Select_int(7  downto 0) <= byte_2(CTL_OFFSET);
                Alg_Select_int(15 downto 8) <= byte_3(CTL_OFFSET);
            end if;
        end if;
    end process;
	
	Alg_Select <= Alg_Select_int;
  
    --Operator 1 MM Connections
  
    Op1_Frequency_Proc:process(clk,reset_n,byte_0,byte_1, Op1_Frequency_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Frequency_int <= (others=>'0');
            else
                Op1_Frequency_int(7  downto 0) <= byte_0(OP1_OFFSET+FREQ_OFFSET);
                Op1_Frequency_int(15 downto 8) <= byte_1(OP1_OFFSET+FREQ_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Feedback_Proc:process(clk,reset_n,byte_2,byte_3,Op1_Feedback_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Feedback_int <= (others=>'0');
            else
                Op1_Feedback_int(7  downto 0) <= byte_2(OP1_OFFSET+FBCK_OFFSET);
                Op1_Feedback_int(15 downto 8) <= byte_3(OP1_OFFSET+FBCK_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Att_M_Proc:process(clk,reset_n,byte_0,byte_1,Op1_Att_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Att_M_int <= (others=>'0');
            else
                Op1_Att_M_int(7  downto 0) <= byte_0(OP1_OFFSET+ATT_OFFSET);
                Op1_Att_M_int(15 downto 8) <= byte_1(OP1_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Att_D_Proc:process(clk,reset_n,byte_3,byte_2,Op1_Att_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Att_D_int <= (others=>'0');
            else
                Op1_Att_D_int(7  downto 0) <= byte_2(OP1_OFFSET+ATT_OFFSET);
                Op1_Att_D_int(15 downto 8) <= byte_3(OP1_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Dec_M_Proc:process(clk,reset_n,byte_0,byte_1,Op1_Dec_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Dec_M_int <= (others=>'0');
            else
                Op1_Dec_M_int(7  downto 0) <= byte_0(OP1_OFFSET+DEC_OFFSET);
                Op1_Dec_M_int(15 downto 8) <= byte_1(OP1_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Dec_D_Proc:process(clk,reset_n,byte_3,byte_2,Op1_Dec_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Dec_D_int <= (others=>'0');
            else
                Op1_Dec_D_int(7  downto 0) <= byte_2(OP1_OFFSET+DEC_OFFSET);
                Op1_Dec_D_int(15 downto 8) <= byte_3(OP1_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Sus_D_Proc:process(clk,reset_n,byte_3,byte_2,Op1_Sus_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Sus_D_int <= (others=>'0');
            else
                Op1_Sus_D_int(7  downto 0) <= byte_2(OP1_OFFSET+SUS_OFFSET);
                Op1_Sus_D_int(15 downto 8) <= byte_3(OP1_OFFSET+SUS_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Rel_M_Proc:process(clk,reset_n,byte_0,byte_1,Op1_Rel_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Rel_M_int <= (others=>'0');
            else
                Op1_Rel_M_int(7  downto 0) <= byte_0(OP1_OFFSET+REL_OFFSET);
                Op1_Rel_M_int(15 downto 8) <= byte_1(OP1_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Rel_D_Proc:process(clk,reset_n,byte_3,byte_2,Op1_Rel_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op1_Rel_D_int <= (others=>'0');
            else
                Op1_Rel_D_int(7  downto 0) <= byte_2(OP1_OFFSET+REL_OFFSET);
                Op1_Rel_D_int(15 downto 8) <= byte_3(OP1_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op1_Frequency <= Op1_Frequency_int;
    Op1_Feedback  <= Op1_Feedback_int;
    Op1_Att_M     <= Op1_Att_M_int;
    Op1_Att_D     <= Op1_Att_D_int;
    Op1_Dec_M     <= Op1_Dec_M_int;
    Op1_Dec_D     <= Op1_Dec_D_int;
    Op1_Sus_D     <= Op1_Sus_D_int;
    Op1_Rel_M     <= Op1_Rel_M_int;
    Op1_Rel_D     <= Op1_Rel_D_int;
    
    --Operator 2 MM Connections
  
    Op2_Frequency_Proc:process(clk,reset_n,byte_0,byte_1, Op2_Frequency_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Frequency_int <= (others=>'0');
            else
                Op2_Frequency_int(7  downto 0) <= byte_0(OP2_OFFSET+FREQ_OFFSET);
                Op2_Frequency_int(15 downto 8) <= byte_1(OP2_OFFSET+FREQ_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Feedback_Proc:process(clk,reset_n,byte_2,byte_3,Op2_Feedback_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Feedback_int <= (others=>'0');
            else
                Op2_Feedback_int(7  downto 0) <= byte_2(OP2_OFFSET+FBCK_OFFSET);
                Op2_Feedback_int(15 downto 8) <= byte_3(OP2_OFFSET+FBCK_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Att_M_Proc:process(clk,reset_n,byte_0,byte_1,Op2_Att_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Att_M_int <= (others=>'0');
            else
                Op2_Att_M_int(7  downto 0) <= byte_0(OP2_OFFSET+ATT_OFFSET);
                Op2_Att_M_int(15 downto 8) <= byte_1(OP2_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Att_D_Proc:process(clk,reset_n,byte_3,byte_2,Op2_Att_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Att_D_int <= (others=>'0');
            else
                Op2_Att_D_int(7  downto 0) <= byte_2(OP2_OFFSET+ATT_OFFSET);
                Op2_Att_D_int(15 downto 8) <= byte_3(OP2_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Dec_M_Proc:process(clk,reset_n,byte_0,byte_1,Op2_Dec_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Dec_M_int <= (others=>'0');
            else
                Op2_Dec_M_int(7  downto 0) <= byte_0(OP2_OFFSET+DEC_OFFSET);
                Op2_Dec_M_int(15 downto 8) <= byte_1(OP2_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Dec_D_Proc:process(clk,reset_n,byte_3,byte_2,Op2_Dec_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Dec_D_int <= (others=>'0');
            else
                Op2_Dec_D_int(7  downto 0) <= byte_2(OP2_OFFSET+DEC_OFFSET);
                Op2_Dec_D_int(15 downto 8) <= byte_3(OP2_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Sus_D_Proc:process(clk,reset_n,byte_3,byte_2,Op2_Sus_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Sus_D_int <= (others=>'0');
            else
                Op2_Sus_D_int(7  downto 0) <= byte_2(OP2_OFFSET+SUS_OFFSET);
                Op2_Sus_D_int(15 downto 8) <= byte_3(OP2_OFFSET+SUS_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Rel_M_Proc:process(clk,reset_n,byte_0,byte_1,Op2_Rel_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Rel_M_int <= (others=>'0');
            else
                Op2_Rel_M_int(7  downto 0) <= byte_0(OP2_OFFSET+REL_OFFSET);
                Op2_Rel_M_int(15 downto 8) <= byte_1(OP2_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Rel_D_Proc:process(clk,reset_n,byte_3,byte_2,Op2_Rel_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op2_Rel_D_int <= (others=>'0');
            else
                Op2_Rel_D_int(7  downto 0) <= byte_2(OP2_OFFSET+REL_OFFSET);
                Op2_Rel_D_int(15 downto 8) <= byte_3(OP2_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op2_Frequency <= Op2_Frequency_int;
    Op2_Feedback  <= Op2_Feedback_int;
    Op2_Att_M     <= Op2_Att_M_int;
    Op2_Att_D     <= Op2_Att_D_int;
    Op2_Dec_M     <= Op2_Dec_M_int;
    Op2_Dec_D     <= Op2_Dec_D_int;
    Op2_Sus_D     <= Op2_Sus_D_int;
    Op2_Rel_M     <= Op2_Rel_M_int;
    Op2_Rel_D     <= Op2_Rel_D_int;
    
    --Operator 3 MM Connections
  
    Op3_Frequency_Proc:process(clk,reset_n,byte_0,byte_1, Op3_Frequency_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Frequency_int <= (others=>'0');
            else
                Op3_Frequency_int(7  downto 0) <= byte_0(OP3_OFFSET+FREQ_OFFSET);
                Op3_Frequency_int(15 downto 8) <= byte_1(OP3_OFFSET+FREQ_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Feedback_Proc:process(clk,reset_n,byte_2,byte_3,Op3_Feedback_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Feedback_int <= (others=>'0');
            else
                Op3_Feedback_int(7  downto 0) <= byte_2(OP3_OFFSET+FBCK_OFFSET);
                Op3_Feedback_int(15 downto 8) <= byte_3(OP3_OFFSET+FBCK_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Att_M_Proc:process(clk,reset_n,byte_0,byte_1,Op3_Att_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Att_M_int <= (others=>'0');
            else
                Op3_Att_M_int(7  downto 0) <= byte_0(OP3_OFFSET+ATT_OFFSET);
                Op3_Att_M_int(15 downto 8) <= byte_1(OP3_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Att_D_Proc:process(clk,reset_n,byte_3,byte_2,Op3_Att_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Att_D_int <= (others=>'0');
            else
                Op3_Att_D_int(7  downto 0) <= byte_2(OP3_OFFSET+ATT_OFFSET);
                Op3_Att_D_int(15 downto 8) <= byte_3(OP3_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Dec_M_Proc:process(clk,reset_n,byte_0,byte_1,Op3_Dec_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Dec_M_int <= (others=>'0');
            else
                Op3_Dec_M_int(7  downto 0) <= byte_0(OP3_OFFSET+DEC_OFFSET);
                Op3_Dec_M_int(15 downto 8) <= byte_1(OP3_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Dec_D_Proc:process(clk,reset_n,byte_3,byte_2,Op3_Dec_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Dec_D_int <= (others=>'0');
            else
                Op3_Dec_D_int(7  downto 0) <= byte_2(OP3_OFFSET+DEC_OFFSET);
                Op3_Dec_D_int(15 downto 8) <= byte_3(OP3_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Sus_D_Proc:process(clk,reset_n,byte_3,byte_2,Op3_Sus_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Sus_D_int <= (others=>'0');
            else
                Op3_Sus_D_int(7  downto 0) <= byte_2(OP3_OFFSET+SUS_OFFSET);
                Op3_Sus_D_int(15 downto 8) <= byte_3(OP3_OFFSET+SUS_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Rel_M_Proc:process(clk,reset_n,byte_0,byte_1,Op3_Rel_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Rel_M_int <= (others=>'0');
            else
                Op3_Rel_M_int(7  downto 0) <= byte_0(OP3_OFFSET+REL_OFFSET);
                Op3_Rel_M_int(15 downto 8) <= byte_1(OP3_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Rel_D_Proc:process(clk,reset_n,byte_3,byte_2,Op3_Rel_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op3_Rel_D_int <= (others=>'0');
            else
                Op3_Rel_D_int(7  downto 0) <= byte_2(OP3_OFFSET+REL_OFFSET);
                Op3_Rel_D_int(15 downto 8) <= byte_3(OP3_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op3_Frequency <= Op3_Frequency_int;
    Op3_Feedback  <= Op3_Feedback_int;
    Op3_Att_M     <= Op3_Att_M_int;
    Op3_Att_D     <= Op3_Att_D_int;
    Op3_Dec_M     <= Op3_Dec_M_int;
    Op3_Dec_D     <= Op3_Dec_D_int;
    Op3_Sus_D     <= Op3_Sus_D_int;
    Op3_Rel_M     <= Op3_Rel_M_int;
    Op3_Rel_D     <= Op3_Rel_D_int;

    --Operator 4 MM Connections
  
    Op4_Frequency_Proc:process(clk,reset_n,byte_0,byte_1, Op4_Frequency_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Frequency_int <= (others=>'0');
            else
                Op4_Frequency_int(7  downto 0) <= byte_0(OP4_OFFSET+FREQ_OFFSET);
                Op4_Frequency_int(15 downto 8) <= byte_1(OP4_OFFSET+FREQ_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Feedback_Proc:process(clk,reset_n,byte_2,byte_3,Op4_Feedback_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Feedback_int <= (others=>'0');
            else
                Op4_Feedback_int(7  downto 0) <= byte_2(OP4_OFFSET+FBCK_OFFSET);
                Op4_Feedback_int(15 downto 8) <= byte_3(OP4_OFFSET+FBCK_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Att_M_Proc:process(clk,reset_n,byte_0,byte_1,Op4_Att_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Att_M_int <= (others=>'0');
            else
                Op4_Att_M_int(7  downto 0) <= byte_0(OP4_OFFSET+ATT_OFFSET);
                Op4_Att_M_int(15 downto 8) <= byte_1(OP4_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Att_D_Proc:process(clk,reset_n,byte_3,byte_2,Op4_Att_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Att_D_int <= (others=>'0');
            else
                Op4_Att_D_int(7  downto 0) <= byte_2(OP4_OFFSET+ATT_OFFSET);
                Op4_Att_D_int(15 downto 8) <= byte_3(OP4_OFFSET+ATT_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Dec_M_Proc:process(clk,reset_n,byte_0,byte_1,Op4_Dec_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Dec_M_int <= (others=>'0');
            else
                Op4_Dec_M_int(7  downto 0) <= byte_0(OP4_OFFSET+DEC_OFFSET);
                Op4_Dec_M_int(15 downto 8) <= byte_1(OP4_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Dec_D_Proc:process(clk,reset_n,byte_3,byte_2,Op4_Dec_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Dec_D_int <= (others=>'0');
            else
                Op4_Dec_D_int(7  downto 0) <= byte_2(OP4_OFFSET+DEC_OFFSET);
                Op4_Dec_D_int(15 downto 8) <= byte_3(OP4_OFFSET+DEC_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Sus_D_Proc:process(clk,reset_n,byte_3,byte_2,Op4_Sus_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Sus_D_int <= (others=>'0');
            else
                Op4_Sus_D_int(7  downto 0) <= byte_2(OP4_OFFSET+SUS_OFFSET);
                Op4_Sus_D_int(15 downto 8) <= byte_3(OP4_OFFSET+SUS_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Rel_M_Proc:process(clk,reset_n,byte_0,byte_1,Op4_Rel_M_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Rel_M_int <= (others=>'0');
            else
                Op4_Rel_M_int(7  downto 0) <= byte_0(OP4_OFFSET+REL_OFFSET);
                Op4_Rel_M_int(15 downto 8) <= byte_1(OP4_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Rel_D_Proc:process(clk,reset_n,byte_3,byte_2,Op4_Rel_D_int)
    begin
        if(clk = '1' and clk'event) then
            if(reset_n = '0') then
                Op4_Rel_D_int <= (others=>'0');
            else
                Op4_Rel_D_int(7  downto 0) <= byte_2(OP4_OFFSET+REL_OFFSET);
                Op4_Rel_D_int(15 downto 8) <= byte_3(OP4_OFFSET+REL_OFFSET);
            end if;
        end if;
    end process;
    
    Op4_Frequency <= Op4_Frequency_int;
    Op4_Feedback  <= Op4_Feedback_int;
    Op4_Att_M     <= Op4_Att_M_int;
    Op4_Att_D     <= Op4_Att_D_int;
    Op4_Dec_M     <= Op4_Dec_M_int;
    Op4_Dec_D     <= Op4_Dec_D_int;
    Op4_Sus_D     <= Op4_Sus_D_int;
    Op4_Rel_M     <= Op4_Rel_M_int;
    Op4_Rel_D     <= Op4_Rel_D_int;
  
END ARCHITECTURE rtl;
