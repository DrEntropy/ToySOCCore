-- Top Level TOYCORE
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

entity TOYCore is
   Port (Clk,Run,Stop,Write : in std_logic;
            CPAddr,CPDataIn : in std_logic_vector(7 downto 0);
            DataOut, DataAddr : out std_logic_vector(7 downto 0)
             );
end TOYCore;

architecture Structural of TOYCore is
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
    DataOut,DataAddr : out std_logic_vector(7 downto 0)


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


signal Zero,Pos,PCInc : std_logic ;
signal CurrOp : std_logic_vector(3 downto 0);
signal ALUOp : std_logic_vector(2 downto 0);
signal MemWE,RFWE,IRHWE,IRLWE,PCWE : std_logic := '0';
signal DPMemWE : std_logic :='0';
signal RFInSel : std_logic_vector(1 downto 0);
signal RFOutAAddrSel,PCAddrSel : std_logic;
signal MemAddrSel : std_logic_vector(1 downto 0);
Signal Reset,TakeOver: std_logic;


begin
   dp : DataPath port map (Clk => Clk,Reset => Reset,CurrentOp => CurrOp,
        Zero=>Zero,Pos=>Pos,ALUOp=>ALUOp,PCInc=>PCInc,MemWE=>DPMemWE,RFWE=>RFWE,
        IRHWE=>IRHWE,IRLWE=>IRLWE,PCWE=> PCWE,RFInSel=>RFInSel,
        RFOutAAddrSel=>RFOutAAddrSel,PCAddrSel=>PCAddrSel,MemAddrSel=>MemAddrSel,
        CPAddr=>CPAddr,CPDataIn=>CPDataIn,TakeOver=>TakeOver,
        DataOut=>DataOut,DataAddr=>DataAddr);
   cont: Control port map (Clk => Clk,Reset => reset,CurrOp => CurrOp,
        Zero=>Zero,Pos=>Pos,ALUOp=>ALUOp,PCInc=>PCInc,MemWE=>MemWE,RFWE=>RFWE,
        IRHWE=>IRHWE,IRLWE=>IRLWE,PCWE=> PCWE,RFInSel=>RFInSel,
        RFOutAAddrSel=>RFOutAAddrSel,PCAddrSel=>PCAddrSel,MemAddrSel=>MemAddrSel
        );


-- TODO: Do we need a synchronizing flip flop on TakeOver?
-- Also, this part is not very structural lol

   DPMemWE <= MemWE Or Write;

   controlproc : Process(clk)
      begin
         if(rising_edge(clk)) then
            if(Stop = '1') then
               TakeOver <= '1';
               Reset <= '1';
            elsif (Run = '1') then
               TakeOver <= '0';
               Reset <= '0';
            end if;
         end if;

      end process;





end Structural;
