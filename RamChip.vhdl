-- simple RAM chip
-- From https://www.youtube.com/user/VhdlBasic, very minor modification


LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- RAM entity
ENTITY RAM IS
  PORT(
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
SIGNAL ADDR : INTEGER RANGE 0 TO 255;

BEGIN

  PROCESS(ADDRESS, DATAIN, W_R)
  BEGIN

    ADDR<=CONV_INTEGER(ADDRESS);
    IF(W_R='1')THEN
      MEMORY(ADDR)<=DATAIN;
    ELSIF(W_R='0')THEN
      DATAOUT<=MEMORY(ADDR);
    ELSE
      DATAOUT<="ZZZZZZZZ";
    END IF;
  END PROCESS;

END Behave;
