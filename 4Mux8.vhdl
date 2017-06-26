--
--
-- libraies

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity FourMux8 is
  port (
     sel: in std_logic_vector(1 downto 0);
     --
     A: in std_logic_vector(7 downto 0);
     B: in std_logic_vector(7 downto 0);
     C: in std_logic_vector(7 downto 0);
     D: in std_logic_vector(7 downto 0);
     Z: out std_logic_vector(7 downto 0)

  );
  end entity FourMux8;


architecture behave of FourMux8 is

begin
   process(sel,A,B,C,D)
    begin
        case sel is
            when "00" =>   Z <= A;
            when  "01" =>   Z <= B;
            when  "10" =>   Z <= C;
            when  "11" =>   Z <= D;
            when others => Z <= (others=>'X');
        end case;
    end process;
end architecture behave;
