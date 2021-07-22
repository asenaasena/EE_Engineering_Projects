----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:33:02 05/05/2017 
-- Design Name: 
-- Module Name:    color_generator - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity color_generator is
  port(reset,vga_clk : in std_logic;
       red,green: out std_logic_vector(2 downto 0);
		 blue: out std_logic_vector(1 downto 0));
end color_generator;

architecture Behavioral of color_generator is

signal temp: std_logic_vector(7 downto 0);

begin
   process(vga_clk,reset)
	begin		
		if(reset='1') then
			temp <= "00000000";
		elsif(vga_clk'event and vga_clk='1') then
				if(temp="11111111") then
					temp<="00000000";
				else 
					temp<=temp + 1;
				end if;
		end if;
	end process;

red(0)<=temp(5);
red(1)<=temp(6);
red(2)<=temp(7);
green(0)<=temp(2);
green(1)<=temp(3);
green(2)<=temp(4);
blue(0)<=temp(0);
blue(1)<=temp(1);

end Behavioral;

