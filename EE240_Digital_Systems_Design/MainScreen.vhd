----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:55 05/22/2017 
-- Design Name: 
-- Module Name:    MainScreen - Behavioral 
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

entity MainScreen is
port(hsync,vsync,pixel_clk,reset,enable,h_porch,v_porch,red,green,yellow,blue,win,lose: in std_logic;
color: out std_logic_vector( 7 downto 0) );
end MainScreen;

architecture Behavioral of MainScreen is
signal hmem: std_logic;
signal pixel_ct: integer range 1 to 640;
signal line_ct: integer range 1 to 480;
signal st1: integer range 0 to 321;
signal fin1: integer range 319 to 641;
signal fin2: integer range 440 to 561;
signal st2: integer range 79 to 201;
signal fin3: integer range 440 to 561;
signal st3: integer range 79 to 201;
signal st4: integer range 199 to 321;
signal fin4: integer range 319 to 441;
begin




pixel: process(reset,pixel_clk,h_porch,v_porch)
begin

if(reset='1') then
	pixel_ct<=1;
	line_ct<=1;
elsif(rising_edge(pixel_clk)) then
		
		if(h_porch='1' and v_porch='1') then
			if(pixel_ct=640) then
				pixel_ct<=1;
				if(line_ct=480) then
					line_ct<=1;
				else
					line_ct<=line_ct+1;
				end if;
			else
				pixel_ct<=pixel_ct+1;
			end if;
		end if;
		
end if;


end process;

geometry: process(line_ct)
begin
if(line_ct<=120 and line_ct>=1) then
st1<=321 - line_ct;
end if;
if(line_ct<=120 and line_ct>=1) then
fin1<=319 + line_ct;
end if;
if(line_ct<=240 and line_ct>=120) then
fin2<=line_ct +319;
end if;
if(line_ct<=240 and line_ct>=120) then
st2<= 320 - line_ct ;
end if;
if(line_ct<=360 and line_ct>=240) then
fin3<=799 - line_ct;
end if;
if(line_ct<=360 and line_ct>=240) then
st3<=line_ct - 160;
end if;
if(line_ct<=480 and line_ct>=360) then
st4<=line_ct - 159;
end if;
if(line_ct<=480 and line_ct>=360) then
fin4<=799 - line_ct ;
end if;

end process;

draw: process(line_ct,pixel_ct,st1,st2,st3,fin1,fin2,fin3,h_porch,v_porch)
begin
if(v_porch='1' and h_porch='1') then
	if(pixel_ct>=st1+3 and pixel_ct<=fin1-3 and line_ct>=3 and line_ct<=120) then 
		if(red='1') then
			color<="00000001";
		else
			color<="00000110";
		end if;
	elsif(pixel_ct>=438 and pixel_ct<=fin2 and line_ct>=120 and line_ct<=240) then
		if(blue='1') then
			color<="01000000";
		else	
			color<="11100000";
		end if;	
	elsif(pixel_ct>=st2+2 and pixel_ct<=202 and line_ct>=120 and line_ct<=240) then
		if(yellow='1') then
			color<="00100100";
		else
			color<="00111111";
		end if;
	elsif(pixel_ct>=438 and pixel_ct<=fin3 and line_ct>=240 and line_ct<=360) then
		if(blue='1') then
			color<="01000000";
		else	
			color<="11100000";
		end if;
	elsif(pixel_ct>=st3+2 and pixel_ct<=202 and line_ct>=240 and line_ct<=360) then
		if(yellow='1') then
			color<="00100100";
		else
			color<="00111111";
		end if;
	elsif(pixel_ct>=st4 and pixel_ct<=fin4 and line_ct>=360 and line_ct<=480) then
		if(green='1') then
			color<="00001000";
		else
			color<="00110000";
			end if;
	else
		if(win='1') then
			color<="00100000";
		elsif(lose='1') then
			color<="00000100";
		else	
			color<="00000000";
		end if;
	end if;
end if;

end process;	
	
	
	
	
end Behavioral;

