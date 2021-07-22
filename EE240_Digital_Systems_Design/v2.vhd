----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:02:13 05/25/2017 
-- Design Name: 
-- Module Name:    v2 - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;


entity v2 is
port (board_clk,res,upbutton,downbutton,leftbutton,rightbutton: in std_logic;
color_out: out std_logic_vector(7 downto 0);
horsync,versync: out std_logic );

end v2;

architecture Behavioral of v2 is
component hv_sync
port(
reset: in std_logic;
slow_clk: in std_logic;
hsync,vsync ,videov,videoh,videoon:out std_logic);
end component;

component freq_div
port(
	clock,reset: in std_logic;
	slow_clk: out std_logic);
	end component;

component MainScreen
port
(hsync,vsync,pixel_clk,reset,enable,h_porch,v_porch,red,green,yellow,blue,win,lose: in std_logic;
color: out std_logic_vector( 7 downto 0) );
end component;

component FrequencyDivider 
port(
	clock,reset: in std_logic;
	slow_clk: out std_logic);
end component;

component Debouncer 
port(
slow_clk, btn: in std_logic;
debounced_out: out std_logic);
end component;
component Random_freq
port(
	clock,reset: in std_logic;
	slow_clk: out std_logic);
end component;
component RandomCounter
port(
fast_clk,reset:in std_logic;
random: out std_logic_vector (9 downto 0) );
end component;

component TheGame 
port(
random: in std_logic_vector( 9 downto 0);
Vsync,btnl,btnr,btnu,btnd,reset:in std_logic;
red,blue,green,yellow,win,lose: out std_logic);
end component;

signal vs,hs,hp,vp,slowed_clk,uporch,r,g,b,y,w,l,deb_clk,debu,debl,debr,debd,rndclk: std_logic;
signal rnd: std_logic_vector (9 downto 0);
begin
u1: freq_div port map (board_clk,res,slowed_clk);
u2: hv_sync port map (res,slowed_clk,hs,vs,vp,hp,uporch);
u3: MainScreen port map (hs,vs,slowed_clk,res,uporch,hp,vp,r,g,y,b,w,l,color_out);
u4: FrequencyDivider port map (board_clk,res,deb_clk); 
u5: RandomCounter port map (rndclk,res,rnd);	
u6: TheGame port map (rnd,vs,debl,debr,debu,debd,res,r,b,g,y,w,l);
u7: Debouncer port map (deb_clk,downbutton,debd);
u8: Debouncer port map (deb_clk,leftbutton,debl);
u9: Debouncer port map (deb_clk,rightbutton,debr);
u10: Debouncer port map (deb_clk,upbutton,debu);
u11: Random_freq port map(board_clk,res,rndclk);
horsync<=hs;
versync<=vs;

end Behavioral;

