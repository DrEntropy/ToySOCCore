----------------------------------------------------------------------------------

-- Create Date: 06/18/2017 09:40:06 AM
-- Design Name:
-- Module Name: ProgramCounter - Behavioral
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ProgramCounter is
    Port ( WriteEnable : in STD_LOGIC;
           AddressIn : in STD_LOGIC_VECTOR (7 downto 0);
           AddressOut : out STD_LOGIC_VECTOR (7 downto 0);
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Increment : in STD_LOGIC);
end ProgramCounter;

architecture Behavioral of ProgramCounter is
  signal CurrentAddress : STD_LOGIC_VECTOR (7 downto 0);  
begin

 AddressOut <= CurrentAddress;
 process (Clk,Reset) is
   begin
    if(Reset='1')then
         CurrentAddress <= (others=>'0');
     else
         if rising_edge(Clk) then
              if(WriteEnable='1') then
                  CurrentAddress <= AddressIn;
               elsif (Increment = '1') then
                  CurrentAddress <= std_logic_vector(unsigned(CurrentAddress)+1);
               end if;
          end if;
      end if;
   end process;


end Behavioral;
