----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/23/2017 12:50:48 PM
-- Design Name: 
-- Module Name: ALU_TestBed - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_TestBed is
--  Port ( );
end ALU_TestBed;

architecture Behavioral of ALU_TestBed is
  signal A,B,Res : std_logic_vector(7 downto 0);
  signal Op : std_logic_vector(2 downto 0);
begin
    AluDUT : entity work.ALU
      port map(A=>A,B=>B,Res=>Res,Op=>Op);
    process 
    begin
    A <= x"00";
    B <= x"20";
    Op <= "001";
    wait for 10 ns;
    A <= x"10";
    B <= x"22";
    wait for 10 ns;
    Op <= "010";
    wait for 10 ns;
    Op <= "011";
    wait for 10 ns;
    Op <= "100";
    wait for 10 ns;
    B <= x"03";
    Op <= "101";
    wait for 10 ns;
    Op <= "110";
    wait for 10 ns;
    end process;

end Behavioral;
