--
--
-- libraies

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity TwoMux8 is
  port (
     sel: in std_logic;
     -- 0 is A, 1 is B
     A: in std_logic_vector(7 downto 0);
     B: in std_logic_vector(7 downto 0);
     Z: out std_logic_vector(7 downto 0)

  );
  end entity TwoMux8;


architecture behave of TwoMux8 is

begin
   process(A,B,sel)
     begin
        case sel is
            when '0' =>   Z <= A;
            when '1' =>   Z <= B;
            when others => Z <= (others=>'X');
        end case;
      end process;
end architecture behave;
