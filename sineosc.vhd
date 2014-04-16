----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:52:14 04/15/2014 
-- Design Name: 
-- Module Name:    sineosc - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sineosc is
    Port ( 
		clk : in STD_LOGIC;
		period : in  STD_LOGIC_VECTOR (15 downto 0);
		audio : out  STD_LOGIC_VECTOR (7 downto 0)
		);
end sineosc;

architecture Behavioral of sineosc is

  COMPONENT counter30_max
    PORT (
      clk: in STD_LOGIC;
      ena : in  STD_LOGIC;
      rst : in  STD_LOGIC;
      max : in  unsigned (29 downto 0);
      count : out  STD_LOGIC_VECTOR (29 downto 0);
      carry : out  STD_LOGIC
      );
  END COMPONENT;

  COMPONENT counter30
    PORT (
      clk : IN STD_LOGIC;
      q : OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
      );
  END COMPONENT;
	
  COMPONENT memory
    PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
  END COMPONENT;
  
  signal period30 : unsigned(29 downto 0) := (others => '0');
  signal addr : STD_LOGIC_VECTOR(29 downto 0);
  signal clkvar : STD_LOGIC;
  signal val : STD_LOGIC_VECTOR(7 downto 0);
  
begin

period30 (15 downto 0) <= unsigned(period);

prog_counter : counter30_max
  PORT MAP (
    clk => clk, 
    ena => '1', 
    rst => '0', 
    max => period30,  
    count => open, 
    carry => clkvar
  );

addr_counter : counter30
  PORT MAP (
    clk => clkvar,
    q => addr
  );
  
rom_memory : memory
  PORT MAP (
    clka => clk,
    addra => addr(9 downto 0),
    douta => val
  );

-- undo unsigned values!
audio(7) <= not val(7);
audio(6 downto 0) <= val(6 downto 0);

end Behavioral;

