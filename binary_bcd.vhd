----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Module Name:    binary_bcd - Behavioral
--
-- Description: Convert binary value into into decimal digits
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_bcd is
    Port ( clk        : in  STD_LOGIC;
           new_binary : in  STD_LOGIC;
           binary     : in  STD_LOGIC_VECTOR (12 downto 0);
           thousands  : out std_logic_vector(3 downto 0);
           hundreds   : out std_logic_vector(3 downto 0);
           tens       : out std_logic_vector(3 downto 0);
           ones       : out std_logic_vector(3 downto 0)
			);
end binary_bcd;

architecture Behavioral of binary_bcd is
   signal busy : std_logic_vector(binary'high+1 downto 0);
   signal t3   : unsigned(3 downto 0);
   signal t2   : unsigned(3 downto 0);
   signal t1   : unsigned(3 downto 0);
   signal t0   : unsigned(3 downto 0);
   signal work : STD_LOGIC_VECTOR (binary'high downto 0);
begin

process(clk)
   begin
      if rising_edge(clk) then
         case t3 is
            when "0000" => t3 <= "0000";
            when "0001" => t3 <= "0010";
            when "0010" => t3 <= "0100";
            when "0011" => t3 <= "0110";
            when "0100" => t3 <= "1000";
            when "0101" => t3 <= "0000";
            when "0110" => t3 <= "0010";
            when "0111" => t3 <= "0100";
            when "1000" => t3 <= "0110";
            when "1001" => t3 <= "1000";
            when others => t3 <= "0000";
         end case;
         if t2 > 4 then
            t3(0) <= '1';
         else
            t3(0) <= '0';
         end if;

         case t2 is
            when "0000" => t2 <= "0000";
            when "0001" => t2 <= "0010";
            when "0010" => t2 <= "0100";
            when "0011" => t2 <= "0110";
            when "0100" => t2 <= "1000";
            when "0101" => t2 <= "0000";
            when "0110" => t2 <= "0010";
            when "0111" => t2 <= "0100";
            when "1000" => t2 <= "0110";
            when "1001" => t2 <= "1000";
            when others => t2 <= "0000";
         end case;
         if t1 > 4 then
            t2(0) <= '1';
         else
            t2(0) <= '0';
         end if;

         case t1 is
            when "0000" => t1 <= "0000";
            when "0001" => t1 <= "0010";
            when "0010" => t1 <= "0100";
            when "0011" => t1 <= "0110";
            when "0100" => t1 <= "1000";
            when "0101" => t1 <= "0000";
            when "0110" => t1 <= "0010";
            when "0111" => t1 <= "0100";
            when "1000" => t1 <= "0110";
            when "1001" => t1 <= "1000";
            when others => t1 <= "0000";
         end case;
         if t0 > 4 then
            t1(0) <= '1';
         else
            t1(0) <= '0';
         end if;


         case t0 is
            when "0000" => t0 <= "0000";
            when "0001" => t0 <= "0010";
            when "0010" => t0 <= "0100";
            when "0011" => t0 <= "0110";
            when "0100" => t0 <= "1000";
            when "0101" => t0 <= "0000";
            when "0110" => t0 <= "0010";
            when "0111" => t0 <= "0100";
            when "1000" => t0 <= "0110";
            when "1001" => t0 <= "1000";
            when others => t0 <= "0000";
         end case;
         t0(0) <= work(work'high);

         work <= work(work'high-1 downto 0) & '0';
         busy <= '0' & busy(busy'high downto 1);

         if busy(0) = '0' then
            -- start a new conversion
            if new_binary = '1' then
               t3   <= (others => '0');
               t2   <= (others => '0');
               t1   <= (others => '0');
               t0   <= (others => '0');
               busy <= (others => '1');
               work <= binary;
            end if;
         else
            if busy(1) = '0' then
               -- conversion complete
               thousands <= std_logic_vector(t3);
               hundreds  <= std_logic_vector(t2);
               tens      <= std_logic_vector(t1);
               ones      <= std_logic_vector(t0);
            end if;
         end if;


      end if;
   end process;

end Behavioral;

