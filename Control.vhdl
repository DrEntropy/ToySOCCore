-- Controller State Machine
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

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.Numeric_Std.ALL;

-- RAM entity
ENTITY Control IS
  PORT(
       Clk,Reset    : IN Std_Logic;

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
END ENTITY;

-- Control architecture
ARCHITECTURE Behave OF Control is
 -- note that state "11" is not used.
Signal State : Std_Logic_Vector(1 Downto 0);
Signal NextState : Std_Logic_Vector(1 Downto 0);

BEGIN


 -- State Register
  PROCESS(Clk,Reset)
  BEGIN
    if(Reset='1') then
      State <= "00";
    elsif(rising_edge(clk)) then
      State <= NextState;
    end if;
  END PROCESS;

-- ALU Op is always this:

  ALUOp <= CurrOp(2 downto 0);

-- now generate the signals based on the state
  process(State,CurrOp,Zero,Pos)

    begin
         -- set all signals to zero (this will be the default)

          RFInSel <= "00"; RFOutAAddrSel <= '0';
          PCAddrSel <= '0';

          MemAddrSel <= "00";
          PCInc <= '0';
          MemWE <= '0';
          RFWE <= '0';
          IRLWE  <= '0';IRHWE <= '0';PCWE <= '0';
          case State is
              when "00" =>

                 -- Fetch high word of instruction
                  NextState <= "01";
                  IRHWE <= '1';
                  MemAddrSel <= "10";
                  PCInc <= '1';
              when "01" =>
              -- Fetch Low word of instruction
                  NextState <= "10";
                  MemAddrSel <= "10";
                  IRLWE <= '1';
                  PCInc <= '1';
              -- Execute instruction
              when "10" =>
                  NextState <= "00";
                  case CurrOp is
                      when x"0" =>
                        null; -- nop
                      -- alu
                      when x"1" | x"2" | x"3" | x"4" | x"5" | x"6"  =>

                        RFInSel <= "01";
                        RFOutAAddrSel <= '0';
                        RFWE <= '1';
                     -- load immediate
                     when x"7" =>
                        RFInSel <= "10";
                        RFWE <= '1';
                    -- load
                     when x"8" =>
                        RFInSel <= "00";
                        RFWE <= '1';
                        MemAddrSel <= "01";
                     -- store
                     when x"9" =>
                        MemWE <= '1';
                        MemAddrSel <= "01";
                        RFOutAAddrSel <= '1';
                    -- load Indirect
                     when x"A" =>
                        RFWE <= '1';
                        RFInSel <= "00";
                        MemAddrSel <= "11";
                     -- store indirect
                     when x"B" =>
                        MemWE <= '1';
                        RFOutAAddrSel <= '1';
                        MemAddrSel <= "11";
                       -- now the branches. Note these are absolute
                      --  Branch z
                    when x"C" =>
                           RFOutAAddrSel <= '1';
                           PCWE <=Zero;  -- tricky right?
                           PCAddrSel <='0';

                    -- branch pos
                    when x"D" =>
                          RFOutAAddrSel <= '1';
                          PCWE <= Pos;
                          PCAddrSel <= '0';

                    --  Jump reg
                    when x"E" =>
                         PCWE <= '1';
                         PCAddrSel <='1';
                         RFOutAAddrSel <= '1';
                    -- Jump and Link
                    when x"F" =>
                        PCWE <= '1';
                        PCAddrSel <= '0';
                        RFInSel <= "11";
                        RFWE <='1';
                    -- this should not happen.
                     when others =>
                         null ;
                  end case;
               when others =>
                 -- should never get here, but just 'in case', and to avoid latches
                    NextState <= "00";

          end case;



    end process;





END Behave;
