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



Component ProgramCounter
    Port ( WriteEnable : in STD_LOGIC;
           AddressIn : in STD_LOGIC_VECTOR (7 downto 0);
           AddressOut : out STD_LOGIC_VECTOR (7 downto 0);
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Increment : in STD_LOGIC);
    end Component;

signal Clk,WE,Reset,Inc : Std_Logic := '0';
signal DIn,Dout : Std_Logic_Vector(7 downto 0);

begin

PC : ProgramCounter PORT MAP(WriteEnable => WE,AddressIn=>Din,AddressOut=>Dout,Reset=> Reset,Clk=>Clk,Increment=>Inc);

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
        Inc <= '1';
        wait for 20 ns;
        Inc <= '0';
        wait for 20 ns;
        DIn <= x"3A";
        WE <= '1';
        wait for 20 ns;
        WE <= '0';
        Inc <= '1';
        wait for 40 ns;
    end process;


end Behavioral;
