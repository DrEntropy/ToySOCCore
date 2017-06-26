----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/24/2017 03:29:00 PM
-- Design Name: 
-- Module Name: muxtest - Behavioral
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

entity muxtest is
--  Port ( );
end muxtest;

architecture Behavioral of muxtest is
signal sel : std_logic;
signal sel2 : std_logic_vector(1 downto 0);
signal A : std_logic_vector(7 downto 0);
signal B:  std_logic_vector(7 downto 0);
signal C : std_logic_vector(7 downto 0);
signal D:  std_logic_vector(7 downto 0);
signal Z,Z2: std_logic_vector(7 downto 0);
begin
dut: entity work.TwoMux8
   port map(sel=>sel,A=>A,B=>B,Z=>z);
dut4: entity work.FourMux8
      port map(sel=>sel2,A=>A,B=>B,C=>C,D=>D,Z=>Z2);

process
  begin
     A<=x"01";
     B<=x"FF";
     C<=x"05";
     D<=x"19";
     sel <= '0';
     sel2 <= "00";
     
     wait for 100 ns;
     sel <= '1';
     sel2 <= "01";
     wait for 100 ns;
     sel2 <= "10";
     wait for 100 ns;
     sel2 <= "11";
     wait for 100 ns;
  end process;

end Behavioral;
