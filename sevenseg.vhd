----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:50:00 12/29/2013 
-- Design Name: 
-- Module Name:    sevenseg - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenseg is
    Port ( clk : in  STD_LOGIC;
           val : in  STD_LOGIC_VECTOR (15 downto 0);
           dps : in  STD_LOGIC_VECTOR (3 downto 0);
           anodes : out  STD_LOGIC_VECTOR (3 downto 0);
           segments : out  STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC
         );
end sevenseg;

architecture Behavioral of sevenseg is

  signal code : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
  signal sgclk : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

begin

segcount_proc: process(clk)
  begin
    if rising_edge(clk) then
      CASE sgclk IS
        WHEN "00" =>
          sgclk <= "01";
          anodes <= "0111";
          dp <= not(dps(0));
          code <= val(3 downto 0);
        WHEN "01" =>
          sgclk <= "10";
          anodes <= "1011";
          dp <= not(dps(1));
          code <= val(7 downto 4);
        WHEN "10" =>
          sgclk <= "11";
          anodes <= "1101";
          dp <= not(dps(2));
          code <= val(11 downto 8);
        WHEN "11" =>
          sgclk <= "00";
          anodes <= "1110";
          dp <= not(dps(3));
          code <= val(15 downto 12);
        WHEN OTHERS =>
          anodes <= "1111";
          dp <= '1';
          code <= "0000";
      END CASE;
    end if;
  end process;
		
  
sevenseg_proc: process(code)
  begin
    CASE code IS
	   WHEN "0000" =>
		  segments <= "1000000";
	   WHEN "0001" =>
	     segments <= "1111001";
		WHEN "0010" =>
		  segments <= "0100100";
		WHEN "0011" =>
		  segments <= "0110000";
		WHEN "0100" =>
		  segments <= "0011001";
		WHEN "0101" =>
		  segments <= "0010010";
		WHEN "0110" =>
		  segments <= "0000010";
		WHEN "0111" =>
		  segments <= "1111000";
		WHEN "1000" =>
		  segments <= "0000000";
		WHEN "1001" =>
		  segments <= "0010000";
		WHEN "1010" =>
		  segments <= "0001000";
		WHEN "1011" =>
		  segments <= "0000011";
		WHEN "1100" =>
		  segments <= "1000110";
		WHEN "1101" =>
		  segments <= "0100001";
		WHEN "1110" =>
		  segments <= "0000110";
		WHEN "1111" =>
		  segments <= "0001110";
		  
		WHEN OTHERS =>
		  segments <= "1111111";
		
    END CASE;
  end process;


end Behavioral;

