-- 2 way 4 bit Mux
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
-- libraies

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity TwoMux4 is
  port (
     sel: in std_logic;
     -- 0 is A, 1 is B
     A: in std_logic_vector(3 downto 0);
     B: in std_logic_vector(3 downto 0);
     Z: out std_logic_vector(3 downto 0)

  );
  end entity TwoMux4;


architecture behave of TwoMux4 is

begin
   process(A,B,sel)
     begin
        case sel is
            when '0' =>   Z <= A;
            when '1' =>   Z <= B;
            when others => Z <= (others=>'X');
        end case;
      end process;
end architecture behave;
