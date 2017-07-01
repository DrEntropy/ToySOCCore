-- RAM Chip. 256 x 8 bit words
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


LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.Numeric_Std.ALL;

-- RAM entity
ENTITY RAM IS
  PORT(
       CLK : In Std_Logic;
       DATAIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       -- Write when 1, Read when 0
       W_R : IN STD_LOGIC;
       DATAOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE Behave OF RAM IS

TYPE MEM IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL MEMORY : MEM;


BEGIN
  DATAOUT <= MEMORY(to_integer(unsigned(ADDRESS)));

  PROCESS(CLK)
  BEGIN
   IF(rising_edge(CLK)) THEN
    IF(W_R='1')THEN
      MEMORY(to_integer(unsigned(ADDRESS)))<=DATAIN;
    END IF;
   END IF;
  END PROCESS;

END Behave;
