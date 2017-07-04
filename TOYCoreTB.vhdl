-- Test Bed for ToyCore.
-- Simply wire it up and test it!
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
USE IEEE.Numeric_Std.ALL;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity TOYCoreTB is
  --  Port ( );
end TOYCoreTB;

architecture Behavioral of TOYCoreTB is
-- use components so i have them for reference!

component ToyCore
  port (
  Clk,Run,Stop,Write : in std_logic;
  CPAddr,CPDataIn : in std_logic_vector(7 downto 0);
 DataOut, DataAddr : out std_logic_vector(7 downto 0)

  );
  end component;


signal clk : std_logic ;
signal CPAddr,CPDataIn,DataOut,DataAddr : std_logic_vector(7 downto 0);
signal Run,Stop : std_logic;
signal Write : std_logic;

begin
   tc : ToyCore port map (Clk => clk,Run => Run, Stop => Stop,
        CPAddr => CPAddr,CPDataIn => CPDataIN,
        Write=>Write,DataOut=>DataOut,DataAddr=>DataAddr);


   -- The clock:
   clock : process
   begin
     clk <= '0';
     wait for 10 ns;
     clk <= '1';
     wait for 10 ns;
   end process clock;



   -- Load the memory using CPAddr and CPDataIn:

   test : process
      file data_in: TEXT;
      variable aline  :  line;
      variable datah : std_logic_vector(7 downto 0);
      variable linenum : integer := 0;
   begin
      Run <= '0';
      Stop <= '1'; -- this keeps the control from running
      --
      -- GOAL: load ram from file
      Write <= '1';
      -- allow a clock cycle to set these values
      wait for 20 ns;
      Stop <= '0'; -- release the button, it has a flip flop so that the
      -- user doesn't have to hold down the button.

      -- replace with path to RamData or any other code  in ascii
      -- hex format. You still need to add to project I think, if using Vivado
      file_open(data_in,"C:/XilinxWork/RamData.txt",READ_MODE);

    while not endfile(data_in) loop
      readline(data_in,aline);
      hread(aline,datah);
      CPAddr <= std_logic_vector(to_unsigned(linenum,8));
      linenum := linenum+1;
      CPDataIn <= datah;
      report "The value of line is"& integer'image(to_integer(unsigned(datah)));
      -- allow the value to clock in
      wait for 20 ns;
    end loop;

    -- memory is now loaded.

    -- Now let it go!
    Write <= '0';
    Run <= '1';
    wait for 20 ns;
    Run <= '0';  -- should hold in run mode.
    wait for 10 ms;  -- arbitrary time, long enough for this program
    assert false report "Simulation Finished" severity failure;
    end process;


end Behavioral;
