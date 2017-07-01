-- 4 way 8 bit Mux
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
--
-- libraies

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity FourMux8 is
  port (
     sel: in std_logic_vector(1 downto 0);
     --
     A: in std_logic_vector(7 downto 0);
     B: in std_logic_vector(7 downto 0);
     C: in std_logic_vector(7 downto 0);
     D: in std_logic_vector(7 downto 0);
     Z: out std_logic_vector(7 downto 0)

  );
  end entity FourMux8;


architecture behave of FourMux8 is

begin
   process(sel,A,B,C,D)
    begin
        case sel is
            when "00" =>   Z <= A;
            when  "01" =>   Z <= B;
            when  "10" =>   Z <= C;
            when  "11" =>   Z <= D;
            when others => Z <= (others=>'X');
        end case;
    end process;
end architecture behave;
