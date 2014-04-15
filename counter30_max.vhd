----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:39:59 12/28/2013 
-- Design Name: 
-- Module Name:    counter30 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter30_max is
    Port ( clk : in  STD_LOGIC;
           ena : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           max : in  unsigned(29 downto 0);
           count : out  STD_LOGIC_VECTOR (29 downto 0);
           carry : out  std_logic
         );
end counter30_max;

architecture Behavioral of counter30_max is

  signal counter : unsigned(29 downto 0) := (others => '0');

begin

  count <= STD_LOGIC_VECTOR(counter);

clk_proc: process(clk, rst)
  begin
    if rst = '1' then
      counter <= (others => '0');
      carry <= '0';
    else
      if rising_edge(clk) then
        if ena = '1' then
--          if counter = max then
          if unsigned(counter) >= max then
            counter <= (others => '0');
            carry <= '1';
          else
            counter <= counter + 1;
            carry <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;

end Behavioral;

