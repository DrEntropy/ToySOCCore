

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.Numeric_Std.ALL;

-- RAM entity
ENTITY RegFile IS
  PORT(
       Clk    : IN Std_Logic_Vector;
       InPort : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       InAddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       OutAAddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       OutBAddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       -- Write when 1, Read when 0
       WE : IN STD_LOGIC;
       OutPortA : Out STD_LOGIC_VECTOR(7 DOWNTO 0);
       OutPortB : Out STD_LOGIC_VECTOR(7 DOWNTO 0);
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE Behave OF RegFile IS

TYPE MEM IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL RFile : MEM;

BEGIN
  OutPortA <= Rfile(to_integer(unsigned(OutAAddr)));
  OutPortB <= Rfile(to_integer(unsigned(OutBAddr)));
  PROCESS(Clk)
  BEGIN
    if(rising_edge(clk)) then
      IF(WE='1')THEN
        RFile(to_integer(unsigned(OutAAddr)))<=InPort;
      end if;
    end if;
  END PROCESS;

END Behave;
