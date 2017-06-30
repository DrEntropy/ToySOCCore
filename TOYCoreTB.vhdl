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
      -- while we load things. We will want to tie takeover to this in teh end
      -- GOAL: load ram from file
      Write <= '1';
      -- allow a clock cycle to set these values
      wait for 20 ns;
      Stop <= '0'; -- release teh button, should do nothing
      -- fucking wierd.
      -- file_open(data_in,"C:/XilinxWork/RamData.txt",READ_MODE);
      file_open(data_in,"D:/RonWorking/XilinixWork/RamData.txt",READ_MODE);
     -- file_open(data_in,"RamData.txt",READ_MODE);
    while not endfile(data_in) loop
      readline(data_in,aline);
      hread(aline,datah);
      CPAddr <= std_logic_vector(to_unsigned(linenum,8));
      linenum := linenum+1;
      CPDataIn <= datah;
      report "The value of line is"& integer'image(to_integer(unsigned(datah)));
      -- allow the value to clcok in
      wait for 20 ns;
    end loop;

    -- Now let it go!
    Write <= '0';
    Run <= '1';
    wait for 20 ns;
    Run <= '0';  -- should hold in run mode.
    wait for 10 ms;  -- arbitrary time, long enouhg for this program
    assert false report "Simulation Finished" severity failure;
    end process;


end Behavioral;
