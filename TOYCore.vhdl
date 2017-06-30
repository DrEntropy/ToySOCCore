-- libraies

library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.Numeric_Std.ALL;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity TOYCore is
  --  Port ( );
end TOYCore;

architecture Behavioral of TOYCore is
-- use components so i have them for reference!

component DataPath
  port (
    Clk,Reset: in std_logic;

    -- Current Operation
    CurrentOp: out std_logic_vector(3 downto 0);
    Zero, Pos: out std_logic;
     -- ALU Control, see ALU.vhdl
    ALUOp: in std_logic_vector(2 downto 0);
    PCInc : in std_logic;
     -- Write enables

       MemWE: in std_logic;
       RFWE: in std_logic;
       IRHWE,IRLWE: in std_logic;
       PCWE: in std_logic;

    -- MUX Control signals

     -- 00: Memout, 01: ALU out, 10: IRL, 11: PC AddressOut
     RFInSel : in std_logic_vector(1 downto 0);

     -- 0: 's', 1:'d'   (sub parts of IRL and IRH)
     RFOutAAddrSel : in std_logic;

     -- 0: IRL, Regfile OutPortA
     PCAddrSel : in std_logic;


     -- 0 : Regfile OutPortA, 1: IRL, 2: PC, 3: Reg Output B ,
     MemAddrSel : in std_logic_vector(1 downto 0);

     -- For the control panel
    CPAddr  : in std_logic_vector(7 downto 0);
    CPDataIn  : in std_logic_vector(7 downto 0);


    -- when takeover is true, CPAddr , CPDataIn  are enabled
    TakeOver : in std_logic;
    -- reflects the current memory output
    DataOut : out std_logic_vector(7 downto 0)

  );
  end component;

 component Control
    port (
         Clk: in std_logic;
         Reset  : IN Std_Logic;

         CurrOp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         Zero, Pos : In Std_Logic;
         -- ALU Control, see ALU.vhdl
     ALUOp: out std_logic_vector(2 downto 0);
      -- increment enable
     PCInc : out std_logic;
      -- Write enables

        MemWE: out std_logic;
        RFWE: out std_logic;
        IRHWE,IRLWE: out std_logic;
        PCWE: out std_logic;

     -- MUX Control signals

      -- 00: Memout, 01: ALU out, 10: IRL, 11: PC AddressOut
      RFInSel : out std_logic_vector(1 downto 0);

      -- 0: 's', 1:'d'   (sub parts of IRL and IRH)
      RFOutAAddrSel : out std_logic;

      -- 0: IRL, Regfile OutPortA
      PCAddrSel : out std_logic;


      -- 0 : Regfile OutPortA, 1: IRL, 2: PC, 3: Reg OutportB
      MemAddrSel : out std_logic_vector(1 downto 0)

         );
  END Component;

signal reset : std_logic := '1';
signal clk,Zero,Pos,PCInc : std_logic ;
signal CurrOp : std_logic_vector(3 downto 0);
signal ALUOp : std_logic_vector(2 downto 0);
signal MemWE,RFWE,IRHWE,IRLWE,PCWE : std_logic := '0';
signal DPMemWE : std_logic :='0';
signal RFInSel : std_logic_vector(1 downto 0);
signal RFOutAAddrSel,PCAddrSel : std_logic;
signal MemAddrSel : std_logic_vector(1 downto 0);
signal CPAddr,CPDataIn,DataOut : std_logic_vector(7 downto 0);
signal TakeOver : std_logic;
signal TakeOverWE : std_logic;

begin
   dp : DataPath port map (Clk => clk,Reset => reset,CurrentOp => CurrOp,
        Zero=>Zero,Pos=>Pos,ALUOp=>ALUOp,PCInc=>PCInc,MemWE=>DPMemWE,RFWE=>RFWE,
        IRHWE=>IRHWE,IRLWE=>IRLWE,PCWE=> PCWE,RFInSel=>RFInSel,
        RFOutAAddrSel=>RFOutAAddrSel,PCAddrSel=>PCAddrSel,MemAddrSel=>MemAddrSel,
        CPAddr=>CPAddr,CPDataIn=>CPDataIn,TakeOver=>TakeOver,
        DataOut=>DataOut);
   cont: Control port map (Clk => clk,Reset => reset,CurrOp => CurrOp,
        Zero=>Zero,Pos=>Pos,ALUOp=>ALUOp,PCInc=>PCInc,MemWE=>MemWE,RFWE=>RFWE,
        IRHWE=>IRHWE,IRLWE=>IRLWE,PCWE=> PCWE,RFInSel=>RFInSel,
        RFOutAAddrSel=>RFOutAAddrSel,PCAddrSel=>PCAddrSel,MemAddrSel=>MemAddrSel
        );

   -- The clock:
   clock : process
   begin
     clk <= '0';
     wait for 10 ns;
     clk <= '1';
     wait for 10 ns;
   end process clock;
   
   DPMemWE <= MemWE Or TakeOverWE;
   
   
   -- Load the memory using CPAddr and CPDataIn:
   
   test : process
      file data_in: TEXT;
      variable aline  :  line;
      variable datah : std_logic_vector(7 downto 0);
      variable linenum : integer := 0;
   begin
      reset <= '1'; -- this keeps the control from running
      -- while we load things. We will want to tie takeover to this in teh end
      -- GOAL: load ram from file
      takeover <= '1';
      TakeOverWE <= '1';
      wait for 20 ns;
      -- fucking wierd.
      file_open(data_in,"C:/XilinxWork/RamData.txt",READ_MODE);
    while not endfile(data_in) loop
      readline(data_in,aline);
      hread(aline,datah);
      CPAddr <= std_logic_vector(to_unsigned(linenum,8));
      linenum := linenum+1;
      CPDataIn <= datah;
      report "The value of line is"& integer'image(to_integer(unsigned(datah)));
      wait for 20 ns;
    end loop;

    -- Now let it go!
    takeover <= '0';
    takeoverWE <= '0';
    reset <= '0';
    wait for 5000 ns;
    assert false report "Simulation Finished" severity failure;
    end process;


end Behavioral;
