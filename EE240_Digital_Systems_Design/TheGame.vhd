----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:04:44 05/25/2017 
-- Design Name: 
-- Module Name:    TheGame - Behavioral 
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
entity TheGame is
port(
random: in std_logic_vector( 9 downto 0);
Vsync,btnl,btnr,btnu,btnd,reset:in std_logic;
red,blue,green,yellow,win,lose: out std_logic);
end TheGame;

architecture Behavioral of TheGame is
--signal mytime: integer range 0 to 6000;
signal temptime: integer range 0 to 3;

signal btnu_old,btnd_old,btnl_old,btnr_old: std_logic;


begin
--timer:process(reset,)
--begin
--if(reset='1') then
--	
--	
--elsif(rising_edge(Vsync)) then
--	mytime<=mytime+1;
--end if;
--end process;

act: process(Vsync,reset)
variable btn_count: integer range 0 to 8;
variable check: std_logic_vector (9 downto 0);
variable mytime: integer range 0 to 6000;
variable start,rantaken,redf,bluef,yellowf,greenf: std_logic;
variable rnd_mem,lvl_mem: std_logic_vector (9 downto 0);
variable ft,wt: integer range 30 to 180; 
variable level: integer range 0 to 5;
variable checklvl: std_logic_vector (5 downto 0);
variable press: integer range 0 to 40;
begin
if(reset='1') then
	check:="0000000000";
	lvl_mem:="0000000000";
	wt:=120;
	ft:=100;
	mytime:=0;
	rantaken:='0';
	level:=1;
	start:='0';
	lose<='0';
	win<='0';
	red<='0';
	green<='0';
	yellow<='0';
	blue<='0';
	btn_count:=0;
	btnu_old<='0';
		btnr_old<='0';
		btnd_old<='0';
		btnl_old<='0';
		press:=0;
elsif(rising_edge(Vsync)) then
	mytime:=mytime+1;
--elsif(mytime=0) then 
	--temptime<=1;
--elsif(btnu='1' and start='0') then
if(btnu='1' and start='0') then
	start:='1';
	rnd_mem:=random;
	mytime:=300;
	--temptime<=0;
elsif(start='1') then
if(mytime=299) then
		win<='0';
elsif(mytime>=300+wt and mytime<300+wt+ft) then
	--win<='0';
	--lose<='0';
	if(rnd_mem(1)='0' and rnd_mem(0)='0') then 
		red<='1';
	elsif(rnd_mem(1)='0' and rnd_mem(0)='1') then 
		yellow<='1';
	elsif(rnd_mem(1)='1' and rnd_mem(0)='0') then 
		green<='1';
	elsif(rnd_mem(1)='1' and rnd_mem(0)='1') then 
		blue<='1';
	end if;
elsif(mytime=300+ft+wt) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
elsif(mytime>=300+ft+(2*wt) and mytime<300+(2*ft)+(2*wt)) then
	if(rnd_mem(3)='0' and rnd_mem(2)='0') then 
		red<='1';
	elsif(rnd_mem(3)='0' and rnd_mem(2)='1') then 
		yellow<='1';
	elsif(rnd_mem(3)='1' and rnd_mem(2)='0') then 
		green<='1';
	elsif(rnd_mem(3)='1' and rnd_mem(2)='1') then 
		blue<='1';
	end if;
elsif(mytime=300+(2*ft)+(2*wt)) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
elsif(mytime>=300+(2*ft)+(3*wt) and mytime<300+(3*ft)+(3*wt)) then
	if(rnd_mem(5)='0' and rnd_mem(4)='0') then 
		red<='1';
	elsif(rnd_mem(5)='0' and rnd_mem(4)='1') then 
		yellow<='1';
	elsif(rnd_mem(5)='1' and rnd_mem(4)='0') then 
		green<='1';
	elsif(rnd_mem(5)='1' and rnd_mem(4)='1') then 
		blue<='1';
	end if;
elsif(mytime=300+(3*ft)+(3*wt)) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
elsif(mytime>=300+(3*ft)+(4*wt) and mytime<300+(4*ft)+(4*wt)) then
	if(rnd_mem(7)='0' and rnd_mem(6)='0') then 
		red<='1';
	elsif(rnd_mem(7)='0' and rnd_mem(6)='1') then 
		yellow<='1';
	elsif(rnd_mem(7)='1' and rnd_mem(6)='0') then 
		green<='1';
	elsif(rnd_mem(7)='1' and rnd_mem(6)='1') then 
		blue<='1';	
	end if;
elsif(mytime=300+(4*ft)+(4*wt)) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
elsif(mytime>=300+(4*ft)+(5*wt) and mytime<300+(5*ft)+(5*wt)) then
	if(rnd_mem(9)='0' and rnd_mem(8)='0') then 
		red<='1';
	elsif(rnd_mem(9)='0' and rnd_mem(8)='1') then 
		yellow<='1';
	elsif(rnd_mem(9)='1' and rnd_mem(8)='0') then 
		green<='1';
	elsif(rnd_mem(9)='1' and rnd_mem(8)='1') then 
		blue<='1';
	end if;
elsif(mytime=300+(5*ft)+(5*wt)) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
elsif(level>=2 and mytime>=300+(5*ft)+(6*wt) and mytime<300+(6*ft)+(6*wt)) then 
	if(lvl_mem(9)='0' and lvl_mem(8)='0') then 
		red<='1';
	elsif(lvl_mem(9)='0' and lvl_mem(8)='1') then 
		yellow<='1';
	elsif(lvl_mem(9)='1' and lvl_mem(8)='0') then 
		green<='1';
	elsif(lvl_mem(9)='1' and lvl_mem(8)='1') then 
		blue<='1';
	end if;
elsif(level>=2 and mytime=300+(6*ft)+(6*wt)) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
elsif(level>=3 and mytime>=300+(6*ft)+(7*wt) and mytime<300+(7*ft)+(7*wt)) then 
	if(lvl_mem(7)='0' and lvl_mem(6)='0') then 
		red<='1';
	elsif(lvl_mem(7)='0' and lvl_mem(6)='1') then 
		yellow<='1';
	elsif(lvl_mem(7)='1' and lvl_mem(6)='0') then 
		green<='1';
	elsif(lvl_mem(7)='1' and lvl_mem(6)='1') then 
		blue<='1';
	end if;
elsif(level>=3 and mytime=300+(7*ft)+(7*wt)) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
elsif(level=4 and mytime>=300+(7*ft)+(8*wt) and mytime<300+(8*ft)+(8*wt)) then 
	if(lvl_mem(5)='0' and lvl_mem(4)='0') then 
		red<='1';
	elsif(lvl_mem(5)='0' and lvl_mem(4)='1') then 
		yellow<='1';
	elsif(lvl_mem(5)='1' and lvl_mem(4)='0') then 
		green<='1';
	elsif(lvl_mem(5)='1' and lvl_mem(4)='1') then 
		blue<='1';
	end if;
elsif(level=4 and mytime=300+(8*ft)+(8*wt)) then		
	blue<='0';
	green<='0';
	red<='0';
	yellow<='0';
	
elsif(mytime>300+((level+4)*(ft+wt)) and mytime<1500+((level+4)*(ft+wt))) then 
	if(bluef='1' or greenf='1' or redf='1' or yellowf='1') then
		if(press=30) then
			blue<='0';
			green<='0';
			red<='0';
			yellow<='0';
			bluef:='0';
			greenf:='0';
			redf:='0';
			yellowf:='0';
			press:=0;
		else
			press:=press+1;
		end if;
	end if;
	if(btnu_old='0' and btnu='1') then
		red<='1';
		redf:='1';
		if(level>1 and btn_count=5) then
			checklvl(1):='0';
			checklvl(0):='0';
		elsif(level>2 and btn_count=6) then 
			checklvl(3):='0';
			checklvl(2):='0';
		elsif(level>3 and btn_count=7) then 
			checklvl(5):='0';
			checklvl(4):='0';
		else	
			check(2*btn_count+1):='0';
			check(2*btn_count):='0';
		end if;
		btn_count:=btn_count+1;
		btnu_old<='1';
		if(rantaken='0') then
			lvl_mem:=random;
			rantaken:='1';
		end if;
	elsif(btnr_old='0' and btnr='1') then
	blue<='1';bluef:='1';
		if(level>1 and btn_count=5) then
			checklvl(1):='1';
			checklvl(0):='1';
		elsif(level>2 and btn_count=6) then 
			checklvl(3):='1';
			checklvl(2):='1';
		elsif(level>3 and btn_count=7) then 
			checklvl(5):='1';
			checklvl(4):='1';
		else	
			check(2*btn_count+1):='1';
			check(2*btn_count):='1';
		end if;
		btn_count:=btn_count+1;
		btnr_old<='1';
		if(rantaken='0') then
			lvl_mem:=random;
			rantaken:='1';
		end if;
	elsif(btnl_old='0' and btnl='1') then
	yellow<='1';yellowf:='1';
		if(level>1 and btn_count=5) then
			checklvl(1):='0';
			checklvl(0):='1';
		elsif(level>2 and btn_count=6) then 
			checklvl(3):='0';
			checklvl(2):='1';
		elsif(level>3 and btn_count=7) then 
			checklvl(5):='0';
			checklvl(4):='1';
		else	
			check(2*btn_count+1):='0';
			check(2*btn_count):='1';
		end if;
		btn_count:=btn_count+1;
		btnl_old<='1';
		if(rantaken='0') then
			lvl_mem:=random;rantaken:='1';
		end if;
	elsif(btnd_old='0' and btnd='1') then
	green<='1';greenf:='1';
		if(level>1 and btn_count=5) then
			checklvl(1):='1';
			checklvl(0):='0';
		elsif(level>2 and btn_count=6) then 
			checklvl(3):='1';
			checklvl(2):='0';
		elsif(level>3 and btn_count=7) then 
			checklvl(5):='1';
			checklvl(4):='0';
		else	
			check(2*btn_count+1):='1';
			check(2*btn_count):='0';
		end if;
		btn_count:=btn_count+1;
		btnd_old<='1';
		if(rantaken='0') then
			lvl_mem:=random;rantaken:='1';
		end if;
	else
		btnu_old<=btnu;
		btnr_old<=btnr;
		btnd_old<=btnd;
		btnl_old<=btnl;
	end if;
---------------------------------------------
	if(btn_count=4+level) then 
		if(rnd_mem=check) then
			if(level=1) then
				win<='1';
				level:=level+1;
				wt:=wt-25;
				ft:=ft-25;
				mytime:=0;
				btn_count:=0;blue<='0';
				green<='0';
				red<='0';
				yellow<='0';
				bluef:='0';
				greenf:='0';
				redf:='0';
				yellowf:='0';
				press:=0;
			elsif(level=2 and lvl_mem(9)=checklvl(1) and lvl_mem(8)=checklvl(0)) then
				win<='1';wt:=wt-25;
				ft:=ft-25;
				level:=level+1;
				mytime:=0;
				btn_count:=0;blue<='0';
				green<='0';
				red<='0';
				yellow<='0';
				bluef:='0';
				greenf:='0';
				redf:='0';
				yellowf:='0';
				press:=0;
			elsif(level=3 and lvl_mem(9)=checklvl(1) and lvl_mem(8)=checklvl(0) and lvl_mem(7)=checklvl(3) and lvl_mem(6)=checklvl(2)) then
				win<='1';wt:=wt-25;
				ft:=ft-25;
				level:=level+1;
				mytime:=0;
				btn_count:=0;blue<='0';
			green<='0';
			red<='0';
			yellow<='0';
			bluef:='0';
			greenf:='0';
			redf:='0';
			yellowf:='0';
			press:=0;
			elsif(level=4 and lvl_mem(9)=checklvl(1) and lvl_mem(8)=checklvl(0) and lvl_mem(7)=checklvl(3) and lvl_mem(6)=checklvl(2) and lvl_mem(5)=checklvl(5) and lvl_mem(4)=checklvl(4)) then
				win<='1';blue<='0';
			green<='0';
			red<='0';
			yellow<='0';
			bluef:='0';
			greenf:='0';
			redf:='0';
			yellowf:='0';
			press:=0;
			else
				lose<='1';blue<='0';
			green<='0';
			red<='0';
			yellow<='0';
			bluef:='0';
			greenf:='0';
			redf:='0';
			yellowf:='0';
			press:=0;
			end if;	
		else
			lose<='1';blue<='0';
			green<='0';
			red<='0';
			yellow<='0';
			bluef:='0';
			greenf:='0';
			redf:='0';
			yellowf:='0';
			press:=0;
			--start:='0';
		end if;
	end if;
elsif(mytime=3000) then
	lose<='1';
	start:='0';
end if;
end if;
end if;
end process;
end Behavioral;

