--
--
-- libraies

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity ALU is
  port (

    -- Control signals

     -- 00: Memout, 01: ALU out, 10: IRL, 11: PC AddressOut
     RegFileInSel : in std_logic_vector(1 downto 0);

     -- 0: 's', 1:'d'   (sub parts of IRL and IRH)
     RFOutAAddrSel : in std_logic;

     -- 0: IRL, Regfile OutPortA
     PCAddrSel : in std_logic;


     -- 0 : Regfile OutPortA, 1: IRL
     MemInSel : in std_logic;
     MemAddrSel : in std_logic;

     -- For the control panel
    CPAddr  : in std_logic_vector(7 downto 0);
    CPDataIn  : in std_logic_vector(7 downto 0);
    
    WE: in std_logic;
    -- when takeover is true, CPAddr , CPDataIn, and WE are enabled
    TakeOver : in std_logic;
    -- reflects the current memory output
    DataOut : out std_logic_vector(7 downto 0)

  );
  end entity ALU;


architecture behave of DataPath is

begin
 -- ...
end architecture behave;
