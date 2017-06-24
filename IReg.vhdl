----------------------------------------------------------------------------------

-- Create Date: 06/18/2017 09:40:06 AM
-- Design Name:
-- Module Name: Instruction register.

-- Note that i will need two of these for my 16 bit instructions
-- which are loaded in two steps.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity IReg is
    Port ( WriteEnable : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (7 downto 0);
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC
           );
end IReg;

architecture Behavioral of IReg is
  signal CurrentData : STD_LOGIC_VECTOR (7 downto 0);
begin

 DataOut <= CurrentData;
 process (Clk,Reset) is
   begin
    if(Reset='1')then
         CurrentData <= (others=>'0');
     else
         if rising_edge(Clk) then
              if(WriteEnable='1') then
                  CurrentData <= DataIn;
               end if;
          end if;
      end if;
   end process;


end Behavioral;
