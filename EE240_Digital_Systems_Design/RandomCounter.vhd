----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:43:12 05/25/2017 
-- Design Name: 
-- Module Name:    RandomCounter - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;
entity RandomCounter is
port(
fast_clk,reset:in std_logic;
random: out std_logic_vector (9 downto 0) );
end RandomCounter;

architecture Behavioral of RandomCounter is
 
begin

count: process(fast_clk,reset)
variable temp: std_logic_vector (9 downto 0);
begin
if(reset='1') then
	temp:="0000000000";
elsif(rising_edge(fast_clk)) then
	if(temp="1111111111") then
		temp:="0000000000";
	else
		temp:=temp+"0000000001";
	end if;
end if;
random<=temp;
end process;

end Behavioral;

