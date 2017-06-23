-- Example created by Kumar Gunasekaran
-- Kumar's VHDLBASIC videos:
--   http://www.youtube.com/playlist?list=PLJ1g6uqLp358rFx54WUUPLi3HxcDLSO_m

-- Testbench for RAM

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.Numeric_Std.ALL;

ENTITY RegTest IS
-- empty
END ENTITY;

ARCHITECTURE BEV OF RegTest IS

SIGNAL InAddr,OutAAddr,OutBAddr : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL DATAIN : STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";
SIGNAL W_R : STD_LOGIC:='1';
SIGNAL ADATAOUT,BDATAOUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Clk : STD_LOGIC;

-- DUT component


COMPONENT RegFile IS
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
END COMPONENT;

BEGIN

  -- Connect DUT
  UUT: RegFile PORT MAP(Clk=>Clk,InPort=>DATAIN,InAddr => InAddr,OutAAddr=>OutAAddr,
      OutBAddr=>OutBAddr,WE=>W_R,OutPortA => ADATAOUT,OutPortB=>BDATAOUT);

 testclock : process
    Begin
      CLK <= '0';
      wait for 10 ns;
      CLK <= '1';
      wait for 10 ns;
    End process testclock;


  PROCESS
    
  BEGIN
    -- Fill in some values
    for regnum in 0 to 15 loop
      DATAIN <= std_logic_vector(to_unsigned(regnum,8));
      InAddr <= std_logic_vector(to_unsigned(regnum,4));
      wait for 20 ns;
    end loop;
    -- Check them
    W_R <= '0';
    OutBAddr <= "0101";
    for regnum in 0 to 15 loop

      OutAAddr <= std_logic_vector(to_unsigned(regnum,4));
      wait for 20 ns;
    end loop;
    -- verifuy that writing to 0 is ingored
    InAddr <= x"0";
    DATAIN <= x"FF";
    wait for 20 ns;
    OutAAddr <= x"0";
    OutBAddr <= x"0";
    wait for 100 ns;
    
  END PROCESS;

END BEV;
