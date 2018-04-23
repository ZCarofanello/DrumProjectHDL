library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SineRom IS
  port (
    clk                 : in  std_logic;
    reset_n             : in  std_logic;
    Dat_Req             : in  std_logic;
    i_Frequency         : in  std_logic_vector(15 downto 0);
    Modulation_Dat      : in  std_logic_vector(15 downto 0);
    SineOut             : out std_logic_vector(15 downto 0)
);
end entity SineRom;

architecture rtl of SineRom is

component Freq2Steps is
  port (
    i_clk       : in  std_logic:='0';
    i_reset_n   : in  std_logic:='1';
    i_Frequency : in  std_logic_vector(15 downto 0):=(others=>'0');
    o_Steps     : out std_logic_vector(15 downto 0):=(others=>'0')
);
end component Freq2Steps;

component SineRomMem IS
  PORT
  (
    address    : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    clock    : IN STD_LOGIC  := '1';
    q        : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END component SineRomMem;

signal CurrentCount,Pitch :std_logic_vector(15 downto 0);
signal Phase        :std_logic_vector(11 downto 0);

begin

    Freq2Steps_inst : Freq2Steps  PORT MAP (
    i_clk       => clk,
    i_reset_n   => reset_n,
    i_Frequency => i_Frequency,
    o_Steps     => Pitch
    );

    FreqCounterProc:process(clk,reset_n,Dat_Req,Pitch)
    begin
        if(clk='1' and clk'event) then
            if(reset_n = '0') then
                CurrentCount <= (others=>'0');
            elsif(Dat_Req = '1') then
                CurrentCount <= std_logic_vector(unsigned(CurrentCount) + unsigned(Pitch));
            else
                CurrentCount <= CurrentCount;
            end if;
        end if;
    end process;
    
    PhaseCalc:process(clk,reset_n,CurrentCount,Modulation_Dat)
    begin
        if(clk='1' and clk'event) then
            if(reset_n = '0') then
                Phase <= (others=>'0');
            else
                Phase <= std_logic_vector(unsigned(CurrentCount(11 downto 0)) + unsigned(Modulation_Dat(15 downto 4)));
            end if;
        end if;
    end process;
        
    SineRomMem_inst : SineRomMem PORT MAP (
    address   => Phase,
    clock   => clk,
    q   => SineOut
  ); 
end architecture rtl;