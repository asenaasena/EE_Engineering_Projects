----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:02:02 05/05/2017 
-- Design Name: 
-- Module Name:    horizontal_sync - Behavioral 
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

entity hv_sync is
  port(
        reset: in std_logic;
		  slow_clk: in std_logic;
		  hsync,vsync ,videov,videoh,videoon:out std_logic);
		  
end hv_sync;

architecture Behavioral of hv_sync is

  signal h_count: std_logic_vector(9 downto 0);
  signal v_count: std_logic_vector(9 downto 0);
  signal videov_1, videoh_1: std_logic;
begin
  h_counter: process (slow_clk, reset)
             begin
                if (reset='1')then 
					     h_count <= "0000000000";
                elsif (slow_clk'event and slow_clk='1') then 
					       if (h_count="1100011111")then 
							     h_count <= "0000000000";
                      else 
							     h_count <= h_count + 1;
                      end if;
                end if;
				 end process;
             
				 process (h_count)
             begin
                 videoh_1 <= '1';
                 if (h_count>"1001111111")then
					     videoh_1 <= '0';
                 end if;
             end process;
				 
  v_counter: process (slow_clk, reset)
            begin
               if reset='1' then 
					   v_count <= "0000000000";
               elsif (slow_clk'event and slow_clk='1') then 
					     if (h_count="1010111011") then 
						      if (v_count="1000001000") then 
								   v_count <= "0000000000";
                        else 
								    v_count <= v_count + 1;
                        end if;
                    end if;
               end if;
           end process;
			  process(v_count)
           begin
               videov_1 <= '1';
               if (v_count>"0111011111") then
   					videov_1 <= '0';
               end if;
           end process;
				 
sync: process (slow_clk, reset)
      begin
          if reset='1' then 
			     hsync <= '0';
              vsync <= '0';
          elsif (slow_clk'event and slow_clk='1') then 
			      if (h_count<="1011110000" and h_count>="1010001111") then 
					    hsync <= '0';
               else 
					    hsync <= '1';
               end if;
               if (v_count >= "0111101000" and v_count<="0111101011") then 
					    vsync <= '0';
               else 
					    vsync <= '1';
               end if;
          end if;
 end process;	 
 
videoh<=videoh_1;
videov<=videov_1;

videoon <= videoh_1 and videov_1;

end Behavioral;

