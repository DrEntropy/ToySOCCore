-- ALU
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
use IEEE.NUMERIC_STD.all;


entity ALU is
  port (
    op : in std_logic_vector(2 downto 0);
    A  : in std_logic_vector(7 downto 0);
    B  : in std_logic_vector(7 downto 0);
    Res: out std_logic_vector(7 downto 0)
  );
  end entity ALU;


architecture behave of ALU is

begin

    process (A,B,op)
    -- Used to simplify the expressions below
      variable sA,sB : signed(7 downto 0);
      begin
        sA := signed(A);
        sB := signed(B);
        case op is
           when "001" =>
                Res <= std_logic_vector(sA+sB);
           when "010" =>
                Res <= std_logic_vector(sA-sB);
           when "011" =>
                Res <= A AND B;
           when "100" =>
                Res <= A OR B;
           when "101" =>
                 -- arithmatic left shift A by B
                Res <= std_logic_vector(shift_left(sA,to_integer(unsigned(B))));
           when "110" =>
                 -- arithmatic right shift A by B

                Res <= std_logic_vector(shift_right(sA,to_integer(unsigned(B))));
           when others =>
                Res <= A;
        end case;


      end process;
end architecture behave;
