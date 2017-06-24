----------------------------------------------------------------------------------

-- Quick and dirty test bench
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity PCTestBench is
--  empty
end PCTestBench;

architecture Behavioral of PCTestBench is



Component IReg
    Port ( WriteEnable : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (7 downto 0);
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC);
    end Component;

signal Clk,WE,Reset,Inc : Std_Logic := '0';
signal DIn,Dout : Std_Logic_Vector(7 downto 0);

begin

IC : IReg PORT MAP(WriteEnable => WE,DataIn=>Din,DataOut=>Dout,Reset=> Reset,Clk=>Clk);

-- CLock
    Clock: process is
    begin
        wait for 10 ns;
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
    end process Clock;
    process is
    begin
        Reset <= '1';
        wait for 50 ns;
        Reset <= '0';
        WE <= '1';
        DIn <= x"3A";
        wait for 20 ns;
    end process;


end Behavioral;
