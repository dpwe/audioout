----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:24 12/29/2013 
-- Design Name: 
-- Module Name:    audioout - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity audioout is
    Port ( clk : in  STD_LOGIC;
           LEDs : out  STD_LOGIC_VECTOR (7 downto 0);
			  Audio : out STD_LOGIC;
			  switches : in STD_LOGIC_VECTOR (7 downto 0);
			  anodes : out STD_LOGIC_VECTOR (3 downto 0);
			  segments : out STD_LOGIC_VECTOR (6 downto 0);
			  dp : out STD_LOGIC;
			  button : in STD_LOGIC;
			  but_up : in STD_LOGIC;
			  but_down : in STD_LOGIC;
			  but_left : in STD_LOGIC;
			  but_right : in STD_LOGIC
			  );
end audioout;

architecture Behavioral of audioout is

  COMPONENT sineosc 
    PORT ( 
		clk : in STD_LOGIC;
		period : in  STD_LOGIC_VECTOR (15 downto 0);
		audio : out  STD_LOGIC_VECTOR (7 downto 0)
	 );
  END COMPONENT;

  COMPONENT dac8
    PORT (
      clk : in STD_LOGIC;
      data : in STD_LOGIC_VECTOR (7 downto 0); 
      PulseStream : out STD_LOGIC
    );
  END COMPONENT;

  COMPONENT ui
    Port ( clk : in  STD_LOGIC;
           LEDs : out  STD_LOGIC_VECTOR (7 downto 0);
           switches : in STD_LOGIC_VECTOR (7 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           segments : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC;
           button : in STD_LOGIC;
           but_up : in STD_LOGIC;
           but_down : in STD_LOGIC;
           but_left : in STD_LOGIC;
           but_right : in STD_LOGIC;
           -- actual outputs
           val0 : out unsigned (15 downto 0);
           val1 : out unsigned (15 downto 0);
           val2 : out unsigned (15 downto 0);
           val3 : out unsigned (15 downto 0);
           val4 : out unsigned (15 downto 0);
           val5 : out unsigned (15 downto 0);
           val6 : out unsigned (15 downto 0);
           val7 : out unsigned (15 downto 0)
           );
  end COMPONENT;

  signal dac_data : STD_LOGIC_VECTOR(7 downto 0);
  signal val0 : unsigned (15 downto 0) := (others => '0');
  signal val1 : unsigned (15 downto 0) := (others => '0');
  signal val2 : unsigned (15 downto 0) := (others => '0');
  signal val3 : unsigned (15 downto 0) := (others => '0');
  signal sineval0 : STD_LOGIC_VECTOR(7 downto 0);
  signal sineval1 : STD_LOGIC_VECTOR(7 downto 0);
  signal sineval2 : STD_LOGIC_VECTOR(7 downto 0);
  signal sineval3 : STD_LOGIC_VECTOR(7 downto 0);

begin

the_ui : ui
  PORT MAP ( 
	 clk => clk,
    LEDs => LEDs,
    switches => switches,
    anodes => anodes,
    segments => segments,
    dp => dp,
    button => button,
    but_up => but_up,
    but_down => but_down,
    but_left => but_left,
    but_right => but_right,
    val0 => val0,
    val1 => val1,
    val2 => val2,
    val3 => val3,
    val4 => open,
    val5 => open,
    val6 => open,
    val7 => open
  );

dac : dac8
  PORT MAP (
    clk => clk, 
    data => dac_data, 
    PulseStream => Audio
  );

sine0 : sineosc
  PORT MAP (
    clk => clk, 
	 period => STD_LOGIC_VECTOR(val0), 
	 audio => sineval0
  );
  
sine1 : sineosc
  PORT MAP (
    clk => clk, 
	 period => STD_LOGIC_VECTOR(val1), 
	 audio => sineval1
  );

sine2 : sineosc
  PORT MAP (
    clk => clk, 
	 period => STD_LOGIC_VECTOR(val2), 
	 audio => sineval2
  );

sine3 : sineosc
  PORT MAP (
    clk => clk, 
	 period => STD_LOGIC_VECTOR(val3), 
	 audio => sineval3
  );

--dac_data <= sineval0 +sineval1;
--LEDs <= dac_data;

--process(clk)
--  begin
--	 if rising_edge(clk) then
      dac_data <= std_logic_vector(signed(sineval0(7) & sineval0(7) & sineval0(7 downto 2)) 
											  + signed(sineval1(7) & sineval1(7) & sineval1(7 downto 2))
											  + signed(sineval2(7) & sineval2(7) & sineval2(7 downto 2))
											  + signed(sineval3(7) & sineval3(7) & sineval3(7 downto 2)));
      --dac_data <= std_logic_vector(signed(sineval0) + signed(sineval1));
--    end if;
--  end process;

end Behavioral;

