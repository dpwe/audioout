----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:24 12/29/2013 
-- Design Name: 
-- Module Name:    ui - Behavioral 
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

entity ui is
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
end ui;

architecture Behavioral of ui is

  COMPONENT counter30
    PORT (
      clk : IN STD_LOGIC;
      q : OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
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
 
  COMPONENT binary_bcd
    PORT (
      clk        : in  STD_LOGIC;
      new_binary : in  STD_LOGIC;
      binary     : in  STD_LOGIC_VECTOR (12 downto 0);
      thousands  : out std_logic_vector(3 downto 0);
      hundreds   : out std_logic_vector(3 downto 0);
      tens       : out std_logic_vector(3 downto 0);
      ones       : out std_logic_vector(3 downto 0)
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
	
  signal count : STD_LOGIC_VECTOR(29 downto 0);

  signal new_binary : STD_LOGIC;
  signal binary : STD_LOGIC_VECTOR(12 downto 0);
  signal sevsegval : STD_LOGIC_VECTOR(15 downto 0);

  signal debounce : STD_LOGIC_VECTOR(19 downto 0);

  signal val : unsigned(15 downto 0) := (others => '0');

  signal reg : unsigned(2 downto 0) := (others => '0');

  signal but_left_down : STD_LOGIC;
  signal but_right_down : STD_LOGIC;

  signal new_reg : STD_LOGIC := '1';  -- make sure it lights a led on startup
  
  signal clk512hz : STD_LOGIC;

  signal my_val0 : unsigned(15 downto 0) := (others => '0');
  signal my_val1 : unsigned(15 downto 0) := (others => '0');
  signal my_val2 : unsigned(15 downto 0) := (others => '0');
  signal my_val3 : unsigned(15 downto 0) := (others => '0');
  signal my_val4 : unsigned(15 downto 0) := (others => '0');
  signal my_val5 : unsigned(15 downto 0) := (others => '0');
  signal my_val6 : unsigned(15 downto 0) := (others => '0');
  signal my_val7 : unsigned(15 downto 0) := (others => '0');
  
  
begin

inst_counter0: counter30_max
  PORT MAP (
    clk => clk,
    ena => '1',
    rst => '0',
    max => to_unsigned(62500, 30), 
    count => open,
    carry => clk512hz
  );

bcd : binary_bcd
  PORT MAP (
    clk        => clk, 
    new_binary => new_binary, 
    binary     => binary, 
    thousands  => sevsegval(15 downto 12), 
    hundreds   => sevsegval(11 downto 8),
    tens       => sevsegval(7 downto 4), 
    ones       => sevsegval(3 downto 0) 
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

val0 <= my_val0;
val1 <= my_val1;
val2 <= my_val2;
val3 <= my_val3;
val4 <= my_val4;
val5 <= my_val5;
val6 <= my_val6;
val7 <= my_val7;

update_ui : process(clk512hz)
begin
  if rising_edge(clk512hz) then
    binary <= std_logic_vector(val(12 downto 0));
    new_binary <= '1';

    -- copy val to appropriate output
    if new_reg = '1' then
      -- the register being operated switched - update val
      case STD_LOGIC_VECTOR(reg) is
        when "000" => val <= my_val0; LEDs <= "00000001"; 
        when "001" => val <= my_val1; LEDs <= "00000010"; 
        when "010" => val <= my_val2; LEDs <= "00000100"; 
        when "011" => val <= my_val3; LEDs <= "00001000"; 
        when "100" => val <= my_val4; LEDs <= "00010000"; 
        when "101" => val <= my_val5; LEDs <= "00100000"; 
        when "110" => val <= my_val6; LEDs <= "01000000"; 
        when "111" => val <= my_val7; LEDs <= "10000000"; 
        when others =>  LEDs <= "00000000"; 
      end case;
      new_reg <= '0';
    else
      -- normal cycle - copy val to correct output
      case STD_LOGIC_VECTOR(reg) is
        when "000" => my_val0 <= val;
        when "001" => my_val1 <= val;
        when "010" => my_val2 <= val;
        when "011" => my_val3 <= val;
        when "100" => my_val4 <= val;
        when "101" => my_val5 <= val;
        when "110" => my_val6 <= val;
        when "111" => my_val7 <= val;
        when others => 
      end case;
      
      -- read buttons including debounce
      if debounce(0) = '0' then
        if button = '0' OR but_up = '0' OR but_down = '0' OR but_left = '0' OR but_right = '0' then
          -- initiate debounce delay
          debounce <= (others => '1');
          if but_up = '0' then
            val <= val + unsigned("00000000" & switches);       
          end if;
          if but_down = '0' then
            val <= val - unsigned("00000000" & switches);       
          end if;
          if but_left = '0' then
            if but_left_down = '0' then
              but_left_down <= '1';
              reg <= reg + 1;
              new_reg <= '1';
            end if;   
          else
            but_left_down <= '0';
          end if;
          if but_right = '0' then
            if but_right_down = '0' then
              but_right_down <= '1';
              reg <= reg - 1;
              new_reg <= '1';
            end if;   
          else
            but_right_down <= '0';
          end if;
		  else
		    -- not debouncing, no but pressed
			 if but_left_down = '1' OR but_right_down = '1' then
			   -- but_right released, also debounce
				debounce <= (others => '1');
				but_right_down <= '0';
				but_left_down <= '0';
			 end if;
		  end if;  -- some button pressed
      else
        -- shift out the debounce delays..
        debounce <= "0" & debounce(19 downto 1);
      end if; -- debounce(0) '0' or '1'
    end if; -- new_reg / normal
  end if; -- rising_512 Hz
end process;

end Behavioral;

