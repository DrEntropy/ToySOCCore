--
--
-- libraies

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity DataPath is
  port (
    Clk,Reset: in std_logic;

    -- Current Operation
    CurrentOp: out std_logic_vector(3 downto 0);

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
     RegFileInSel : in std_logic_vector(1 downto 0);

     -- 0: 's', 1:'d'   (sub parts of IRL and IRH)
     RFOutAAddrSel : in std_logic;

     -- 0: IRL, Regfile OutPortA
     PCAddrSel : in std_logic;


     -- 0 : Regfile OutPortA, 1: IRL
     MemInSel : in std_logic;
     -- 0 : Regfile OutPortA, 1: IRL, 2: PC, 3: DONT USE , but will force takeover
     MemAddrSel : in std_logic_vector(1 downto 0);

     -- For the control panel
    CPAddr  : in std_logic_vector(7 downto 0);
    CPDataIn  : in std_logic_vector(7 downto 0);


    -- when takeover is true, CPAddr , CPDataIn  are enabled
    TakeOver : in std_logic;
    -- reflects the current memory output
    DataOut : out std_logic_vector(7 downto 0)

  );
  end entity DataPath;


architecture behave of DataPath is
 signal ALURes : std_logic_vector(7 downto 0);
 signal CurrentInstH,CurrentInstL : std_logic_vector(7 downto 0);
 signal MemoryOut :std_logic_vector(7 downto 0);
 signal PCIn, PCAddress : std_logic_vector(7 downto 0);
 signal MemInput,MemAddr : std_logic_vector(7 downto 0);
 signal MemMuxAddrSel,MemMuxInSel: std_logic_vector(1 downto 0);

 signal RFOutA,RFOutB, RFIn : std_logic_vector(7 downto 0);
 signal RFOutAAddr : std_logic_vector (3 downto 0);
begin
 -- ...
 ALU : entity work.ALU
    port map (op => ALUop,A => RFOutA,B => RFOutB,Res => ALURes);

 -- Contains s, t or addr
 IRegL: entity work.IReg
    port map (WriteEnable => IRLWE,DataIn=> MemoryOut,DataOut=> CurrentInstL,Reset=> Reset,Clk=> Clk);
 -- Contains op and d
 IRegH: entity work.IReg
       port map (WriteEnable => IRHWE,DataIn=> MemoryOut,DataOut=> CurrentInstH,Reset=> Reset,Clk=> Clk);
       
 CurrentOp <= CurrentInstH(7 downto 4);

 PC : entity work.ProgramCounter
        port map (WriteEnable => PCWE,AddressIn => PCIn, AddressOut =>PCAddress,Reset=> Reset,Clk=> Clk, Increment => PCInc);

 PCMux  : entity work.TwoMux8
       port map (sel =>  PCAddrSel,A=> CurrentInstL,B=> RFOutA,Z=> PCIn);
-- RAM wire up
 RAM: entity work.RAM
       port map (CLK => Clk, DATAIN=> MemInput,ADDRESS=> MemAddr,W_R => MemWE, DATAOUT=> MemoryOut);

DataOut <= MemoryOut;

 -- I think this syntax is right... check it :)
 MemMuxAddrSel <= MemAddrSel when Takeover = '0' else "11";

 MemMuxInSel <= TakeOver&MemInSel;

 MemAddrMux: entity work.FourMux8
       port map (sel => MemMuxAddrSel ,A=> RFOutA,B=>CurrentInstL , C=>PCAddress, D=>CPAddr, Z=> MemAddr);

 MemDataMux: entity work.FourMux8
       port map (sel => MemMuxInSel ,A=> RFOutA,B=>CurrentInstL , C=>CPDataIn, D=>CPDataIn, Z=> MemInput);

--- RFile wire up
 RFile: entity work.RegFile
       port map (Clk => Clk, InPort => RFIn,InAddr=>CurrentInstH(3 downto 0),OutAAddr => RFOutAAddr,
       OutBAddr => CurrentInstL(3 downto 0),WE=> RFWE,OutPortA => RFOutA,OutPortB => RFOutB);

   -- 00: Memout, 01: ALU out, 10: IRL, 11: PC AddressOut (for link)
 RFInMux : entity work.FourMux8
       port map (sel => RegFileInSel,A => MemoryOut,B=> ALURes, C => CurrentInstL, D=> PCAddress,Z=> RFIn);



 RFOutAMux : entity work.TwoMux4
        port map (sel =>  RFOutAAddrSel, A=> CurrentInstL(7 downto 4),B=> CurrentInstH(3 downto 0),Z=> RFOutAAddr);




end architecture behave;
