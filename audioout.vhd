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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

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
	
  COMPONENT dac8
    PORT (
      clk : IN STD_LOGIC;
      data : IN STD_LOGIC_VECTOR(7 downto 0);
      PulseStream : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT binary_bcd
    PORT (
      clk        : in  STD_LOGIC;
      new_binary : in  STD_LOGIC;
      binary     : in  STD_LOGIC_VECTOR (12 downto 0);
      thousands  : out std_logic_vector(3 downto 0);
      hundreds   : out std_logic_vector(3 downto 0);
      tens       : out std_logic_vector(3 downto 0);
      ones       : out std_logic_vector(3 downto 0);
      tenths     : out std_logic_vector(3 downto 0);
      hundredths : out std_logic_vector(3 downto 0)
      );
  END COMPONENT;

  COMPONENT sevenseg
    Port (
      clk : in  STD_LOGIC;
      val : in  STD_LOGIC_VECTOR (15 downto 0);
      dps : in  STD_LOGIC_VECTOR (3 downto 0);
      anodes : out  STD_LOGIC_VECTOR (3 downto 0);
      segments : out  STD_LOGIC_VECTOR (6 downto 0);
      dp : out STD_LOGIC
      );
  END COMPONENT;
	
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
 
  signal count : STD_LOGIC_VECTOR(29 downto 0);
  signal dac_data : STD_LOGIC_VECTOR(7 downto 0);
  signal audio_bit : STD_LOGIC;

  signal new_binary : STD_LOGIC;
  signal binary : STD_LOGIC_VECTOR(12 downto 0);
  signal sevsegval : STD_LOGIC_VECTOR(15 downto 0);

  signal clk512hz : std_logic;
  signal clkvar : std_logic;
  signal clkvarmax : unsigned(29 downto 0) := (others => '0');
  signal clkvarcount : STD_LOGIC_VECTOR(29 downto 0);
  signal clkvar_rst : std_logic;

  signal debounce : STD_LOGIC_VECTOR(19 downto 0);

begin

addr_counter : counter30
  PORT MAP (
    clk => clkvar,
    q => count
  );
  
rom_memory : memory
  PORT MAP (
    clka => clk,
    addra => count(9 downto 0),
    douta => dac_data
  );

dac : dac8
  PORT MAP (
    clk => clk, 
    data => dac_data, 
    PulseStream => audio_bit
  );
  
LEDs(6 downto 0) <= dac_data(7 downto 1);
LEDs(7) <= audio_bit;
Audio <= audio_bit;

bcd : binary_bcd
  PORT MAP (
    clk        => clk, 
    new_binary => new_binary, 
    binary     => binary, 
    thousands  => sevsegval(15 downto 12), 
    hundreds   => sevsegval(11 downto 8),
    tens       => sevsegval(7 downto 4), 
    ones       => sevsegval(3 downto 0), 
    tenths     => open,
    hundredths => open
  );

inst_counter0: counter30_max
  PORT MAP (
    clk => clk,
    ena => '1',
    rst => '0',
    max => to_unsigned(62500, 30), 
    count => open,
    carry => clk512hz
  );

prog_counter : counter30_max
  PORT MAP (
    clk => clk, 
    ena => '1', 
    rst => clkvar_rst, 
    max => clkvarmax,  
    count => clkvarcount, 
    carry => clkvar
  );

sevseg : sevenseg
  Port MAP (
    clk => clk512hz, 
    val => sevsegval, 
    dps => "0000", 
    anodes => anodes, 
    segments => segments, 
    dp => dp
  );

check_switches : process(clk512hz)
begin
  if rising_edge(clk512hz) then
	  -- binary <= "000" & switches & "00";
	  binary <= std_logic_vector(clkvarmax(10 downto 0)) & "00";
	  -- Button is 0 when pressed
	  -- new_binary <= NOT button;
	  new_binary <= '1';
	--  clkvarmax <= unsigned("000000000000000000000" & switches & "1");
	  -- debounce delay
	  if debounce(0) = '0' then
		 if button = '0' OR but_up = '0' OR but_down = '0' OR but_left = '0' OR but_right = '0' then
			-- initiate debounce delay
			debounce <= (others => '1');
			if but_up = '0' then
			  clkvarmax <= clkvarmax + unsigned("0000000000000000000000" & switches);
			end if;
			if but_down = '0' then
			  clkvarmax <= clkvarmax - unsigned("0000000000000000000000" & switches);
			end if;
		 end if;
	  else
		 -- shift out the debounce delays..
		 debounce <= "0" & debounce(19 downto 1);
	  end if;
	end if;
  
end process;

end Behavioral;

