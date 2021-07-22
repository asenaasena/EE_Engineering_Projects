----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:29:01 05/26/2017 
-- Design Name: 
-- Module Name:    Random_freq - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity Random_freq is
	port(
	clock,reset: in std_logic;
	slow_clk: out std_logic);
end Random_freq;

architecture Behavioral of Random_freq is
	

	
    signal temp: STD_LOGIC;
    signal counter : integer range 0 to 12 := 0;
begin
    frequency_divider: process (clock,reset) begin
        if (reset = '1') then
            temp <= '0';
            counter <= 0;
        elsif rising_edge(clock) then
            if (counter = 12) then
                temp <= NOT(temp);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    slow_clk<= temp;
end Behavioral;
