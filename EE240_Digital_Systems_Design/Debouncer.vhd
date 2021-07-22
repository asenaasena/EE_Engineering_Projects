----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:53:40 04/13/2017 
-- Design Name: 
-- Module Name:    Debouncer - Behavioral 
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

entity Debouncer is
port(
slow_clk, btn: in std_logic;
debounced_out: out std_logic);
end Debouncer;

architecture Behavioral of Debouncer is
component FDCE 
port (Q : out STD_LOGIC;
C : in STD_LOGIC;
CE : STD_LOGIC;
CLR : in STD_LOGIC;
D :in STD_LOGIC );
end component; 
signal a1,a2,a3,a4: std_logic;


begin

u1: FDCE port map(a1,slow_clk,'1','0',btn);
u2: FDCE port map(a2,slow_clk,'1','0',a1);
u3: FDCE port map(a3,slow_clk,'1','0',a2);
u4: FDCE port map(a4,slow_clk,'1','0',a3);

debounced_out<= a1 and a2 and a3 and a4 ;

end Behavioral;

