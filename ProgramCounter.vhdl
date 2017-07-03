-- Program Counter
----------------------------------------------------------------------------
-- ToyCore CPU implements the TOY ISA from "Computer Science: An Interdisciplinary Approach" by
-- Robert Sedgewick and Kevin Wayne.
-- Implemented by Ron Legere
---------------------------------------------------------------------------
--  This file is part of ToyCore

--    ToyCore is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.

--    ToyCore is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.

--    You should have received a copy of the GNU General Public License
--    along with ToyCore.  If not, see <http://www.gnu.org/licenses/>.
--


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ProgramCounter is
    Port ( WriteEnable : in STD_LOGIC;
           AddressIn : in STD_LOGIC_VECTOR (7 downto 0);
           AddressOut : out STD_LOGIC_VECTOR (7 downto 0);
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Increment : in STD_LOGIC);
end ProgramCounter;

architecture Behavioral of ProgramCounter is
  signal CurrentAddress : STD_LOGIC_VECTOR (7 downto 0);
begin

 AddressOut <= CurrentAddress;
 process (Clk,Reset) is
   begin
    if(Reset='1')then
         CurrentAddress <= (others=>'0');
     else
         if rising_edge(Clk) then
              if(WriteEnable='1') then
                  CurrentAddress <= AddressIn;
               elsif (Increment = '1') then
                  CurrentAddress <= std_logic_vector(unsigned(CurrentAddress)+1);
               end if;
          end if;
      end if;
   end process;


end Behavioral;
