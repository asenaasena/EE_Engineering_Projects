--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:34:27 05/23/2017
-- Design Name:   
-- Module Name:   C:/Users/Oguzhan/ColorMemory/hv_sync_tb.vhd
-- Project Name:  ColorMemory
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hv_sync
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
--USE ieee.numeric_std.ALL;
 
ENTITY hv_sync_tb IS
END hv_sync_tb;
 
ARCHITECTURE behavior OF hv_sync_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hv_sync
    PORT(
         reset : IN  std_logic;
         slow_clk : IN  std_logic;
         hsync : OUT  std_logic;
         vsync : OUT  std_logic;
         videov : OUT  std_logic;
         videoh : OUT  std_logic;
         videoon : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal slow_clk : std_logic := '0';

 	--Outputs
   signal hsync : std_logic;
   signal vsync : std_logic;
   signal videov : std_logic;
   signal videoh : std_logic;
   signal videoon : std_logic;

   -- Clock period definitions
   constant slow_clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: hv_sync PORT MAP (
          reset => reset,
          slow_clk => slow_clk,
          hsync => hsync,
          vsync => vsync,
          videov => videov,
          videoh => videoh,
          videoon => videoon
        );

   -- Clock process definitions
   slow_clk_process :process
   begin
		slow_clk <= '0';
		wait for slow_clk_period/2;
		slow_clk <= '1';
		wait for slow_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      
reset<='1';
		wait for 100 ns;
		reset <='0';
      
      -- insert stimulus here 

      wait;
   end process;

END;
