
-- this is just some quick checks to make sure nothing obviously broken.
-- more detailed checks will be driven by the controller state machine

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity TestDP is
--  Port ( );
end TestDP;

architecture Behavioral of TestDP is

component DataPath
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

  -- singals to manipulate oh my!  Almost just a repeat of teh above. Verbosity !
signal Clk, Reset, PCInc,TakeOver : std_logic := '0';
signal CurrentOp : std_logic_vector(3 downto 0) := "0000";
signal ALUOp : std_logic_vector(2 downto 0) := "000";
signal MemWE,RFWE,IRHWE,IRLWE,PCWE : std_logic := '0';

signal RegFileInSel, MemAddrSel: std_logic_vector(1 downto 0) := "00";
signal RFOutAAddrSel,PCAddrSel: std_logic := '0';
signal CPAddr, CPDataIn,DataOut : std_logic_vector (7 downto 0);

begin

  dut : DataPath port map (Clk,Reset,CurrentOp,ALUOp,PCInc,MemWE,RFWE,IRHWE,IRLWE,
            PCWE,RegFileInSel,RFOutAAddrSel,PCAddrSel, MemAddrSel,CPAddr,CPDataIn,TakeOver,DataOut);


clock : process
begin
  clk <= '0';
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
end process clock;

test : process
begin
   reset <= '1';
   wait for 20 ns;
   reset <= '0';
   -- load 30 memory locations
 for i in 1 to 30 loop
   takeover <= '1';
   MemWE <= '1';
   CPAddr <= std_logic_vector(to_unsigned(i-1,8));
   CPDataIn <= std_logic_vector(to_unsigned(i,8));
   wait for 20 ns;
 end loop;
 --  at this point memory is loaded with some stuff. Now simulate R[d] <- M[addr] (indirect load)
 --   I need to put that instruction in memory somewhere to get it into the IRL IRH
 --  It will have to be 0 and 1 since that is where the PC counter should be after reset
     CPAddr <= x"00";
     CPDataIn <= x"81" ; -- use register 1, remmeber r0 is always zero
     wait for 20 ns;
     CPAddr <= x"01";
     CPDataIn <= x"06";  -- data is at lcoation 6
     wait for 20 ns;
     takeover <= '0';
     MemWE <= '0';

 --  Load the first instruction
    IRHWE <= '1';
    MemAddrSel <= "10";  -- use pc for address
    PCInc <= '1'; -- and increment it
    wait for 20 ns;
    IRHWE <= '0';
    IRLWE <= '1'; -- load teh other
    wait for 20 ns;
    ---- LOAD the reg file.
    IRLWE <= '0';
    PCInc <= '0'; -- freeze
    RegFileInSel <= "00";  -- memory
    RFWE <='1';
    MemAddrSel <= "01"; -- Use IRL for address
    wait for 20 ns;-- so far so good!
    -- Now I want to load reg file 2, and add them up into 3.
    -- Need to repeat some stuff here.
    RFWE <= '0';
    MemWE <= '1';
    TakeOver <= '1';
    CPAddr <= x"02";
    CPDataIn <= x"72" ; -- use register 2
    wait for 20 ns;
    CPAddr <= x"03";
    CPDataIn <= x"12";  -- data is 12  . Below this will be re-interpreted as reg 1 and 2 !
    wait for 20 ns;
    takeover <= '0';
    MemWE <= '0';
    --- Load IR
     --  Load the 2nd instruction
    IRHWE <= '1';
    MemAddrSel <= "10";  -- use pc for address
    PCInc <= '1'; -- and increment it
    wait for 20 ns;
    IRHWE <= '0';
    IRLWE <= '1'; -- load teh other
    wait for 20 ns;
    IRLWE <= '0';
    PCInc <= '0'; -- freeze
    --- load immediate
    RegFileInSel <= "10";  -- IRL
    RFWE <='1';
    wait for 20 ns;
    RFOutAAddrSel <= '0'; -- Use s
    ALUOp <= "001";
    RegFileInSel <= "01"; -- ALU
    -- Note, at this poitn d=2, s = 1, t =2 due to teh way i set things up!
    wait for 20 ns;
    -- Ok works up to here. ONE last thing, lets write r2 to whereever the PC is pointed, which I think
    -- is 4

    RFWE <= '0';
    -- set the muxes
    RFOutAAddrSel <= '1'; -- Use d not s
    MemAddrSel <= "10";  -- use PC
    MemWE <= '1';
    wait for 20 ns;
    MemWE <= '0';
    wait for 20 ns;

end process test;


end Behavioral;
