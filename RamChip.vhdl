-- simple RAM chip
-- From https://www.youtube.com/user/VhdlBasic, very minor modification


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
