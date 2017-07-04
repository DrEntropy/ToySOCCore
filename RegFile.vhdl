-- 16 x 8 register file. Note that element 0 is always 0
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

-- Regfile entity
-- This is a two outport, one inport register file. 16 registers,
-- register 0 is always 0 and any writes to it will be ignored.

ENTITY RegFile IS
  PORT(
       Clk    : IN Std_Logic;
       InPort : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       InAddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       OutAAddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       OutBAddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       -- Write when 1, Read when 0
       WE : IN STD_LOGIC;
       OutPortA : Out STD_LOGIC_VECTOR(7 DOWNTO 0);
       OutPortB : Out STD_LOGIC_VECTOR(7 DOWNTO 0)
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE Behave OF RegFile IS

TYPE MEM IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL RFile : MEM;

BEGIN
-- note that always return zero when address 0 is asked for.

  OutPortA <= x"00" when OutAAddr = x"0" else  Rfile(to_integer(unsigned(OutAAddr)));
  OutPortB <= x"00" when OutBAddr = x"0" else  Rfile(to_integer(unsigned(OutBAddr)));
  PROCESS(Clk)
  BEGIN
    if(rising_edge(clk)) then
      IF(WE='1')THEN
        RFile(to_integer(unsigned(InAddr)))<=InPort;
      end if;
    end if;
  END PROCESS;

END Behave;
