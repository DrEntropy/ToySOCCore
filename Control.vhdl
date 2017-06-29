

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.Numeric_Std.ALL;

-- RAM entity
ENTITY Control IS
  PORT(
       Clk,Reset    : IN Std_Logic;

       CurrOp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
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
    RegFileInSel : out std_logic_vector(1 downto 0);

    -- 0: 's', 1:'d'   (sub parts of IRL and IRH)
    RFOutAAddrSel : out std_logic;

    -- 0: IRL, Regfile OutPortA
    PCAddrSel : out std_logic;



    -- 0 : Regfile OutPortA, 1: IRL, 2: PC, 3: DONT USE , but will force takeover
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
  process(State,CurrOp)

    begin
         -- set all signals to zero (this will be the default)

          RegFileInSel <= "00"; RFOutAAddrSel <= '0';
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
                  MemAddrSel <= "10"
                  IRLWE <= '1';
                  PCInc <= '1';
              -- Execute instruction
              when "10" =>
                  NextState <= "00";
                  case CurrOp is
                      when x"00" =>
                        null; -- nop
                      -- alu
                      when x"01" | x"02" | x"03" | x"04" | x"05" | x"06" | x"06" =>

                        RegFileInSel <= "01";
                        RFOutAAddrSel <= '0';
                        RFWE <= '1';
                     -- load immediate
                     when x"07" =>
                        RegFileInSel <= "10";
                        RFWE <= '1';
                    -- load
                     when x"08" =>
                        RegFileInSel <= "00";
                        RFWE <= '1';
                        MemAddrSel <= "01";
                     -- store
                     when x"09" =>
                        MemWE <= '1';
                        MemAddrSel <= "01";
                        RFOutAAddrSel <= '1';




                     when others =>
                         null ;
                  end case;
               when others =>
                 -- should never get here, but just 'in case', and to avoid latches
                    NextState <= "00";

          end case;



    end process;





END Behave;
