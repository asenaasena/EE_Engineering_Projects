--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:47:03 05/05/2017
-- Design Name:   
-- Module Name:   C:/Users/user/Desktop/COURSES/EE 240/lab7/VGA_color/color_generator_tb.vhd
-- Project Name:  VGA_color
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: color_generator
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY color_generator_tb IS
END color_generator_tb;
 
ARCHITECTURE behavior OF color_generator_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT color_generator
    PORT(
         reset : IN  std_logic;
         vga_clk : IN  std_logic;
         red : OUT  std_logic_vector(2 downto 0);
         green : OUT  std_logic_vector(2 downto 0);
         blue : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal vga_clk : std_logic := '0';

 	--Outputs
   signal red : std_logic_vector(2 downto 0);
   signal green : std_logic_vector(2 downto 0);
   signal blue : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant vga_clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: color_generator PORT MAP (
          reset => reset,
          vga_clk => vga_clk,
          red => red,
          green => green,
          blue => blue
        );

   -- Clock process definitions
   vga_clk_process :process
   begin
		vga_clk <= '0';
		wait for vga_clk_period/2;
		vga_clk <= '1';
		wait for vga_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for vga_clk_period*10;

      -- insert stimulus here 
      reset<='1';
		wait for 10 ns;
		reset <= '0';
      wait;
   end process;

END;
