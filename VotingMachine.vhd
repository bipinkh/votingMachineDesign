----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:30:19 08/07/2017 
-- Design Name: 
-- Module Name:    VotingMachine - Behavioral 
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VotingMachine is
Port
	(
	
		clk : in std_logic;
		reset : in std_logic;
		party1 : in std_logic;
		party2 : in std_logic;
		party3 : in std_logic;
		select_party : in std_logic;
		
		count1_op : out std_logic_vector(5 downto 0);
		count2_op : out std_logic_vector(5 downto 0);
		count3_op : out std_logic_vector(5 downto 0)	
	);
end VotingMachine;

architecture Behavioral of VotingMachine is
signal count1,count2,count3: std_logic_vector(5 downto 0);  --for performing arithmetic operation and displaying giving to output
signal state: std_logic_vector(5 downto 0); --6 states
constant initial: std_logic_vector(5 downto 0):=  "000001";		--state1
constant check: std_logic_vector(5 downto 0):=  "000010";	--state2
constant party1_state: std_logic_vector(5 downto 0):=  "000100";	--state3
constant party2_state: std_logic_vector(5 downto 0):=  "001000";	--state4
constant party3_state: std_logic_vector(5 downto 0):=  "010000";	--state5
constant done: std_logic_vector(5 downto 0):=  "100000";	--state6

begin

process (clk, reset, party1, party2, party3)
begin
	if (reset='1')then
		count1 <= (others=>'0');
		count2 <= (others=>'0');
		count3 <= (others=>'0');
		state <= initial;
	else
		if (rising_edge(clk) and reset='0') then 
		-- NSL : Next State Logic
			case state is 
				when initial =>
					--NSL
					if (party1='1' or party2='1' or party3='1') then
						state <=check;
					else
						state <= initial;
					--OFL
					end if;
				
				when check=>
					--NSL
					if (party1='1') then
						state <= party1_state;
					elsif (party2='1') then
						state <= party2_state;
					elsif (party3='1') then
						state <= party3_state;
					else
						state<=check;
					end if;
					--OFL
					
				when party1_state=>
					--NSL
					if (select_party='1') then
						state <= done;
					else
						state <= party1_state;
					end if;
					--OFL
					count1 <= count1 +1;
					
				when party2_state=>
					--NSL
					if (select_party='1') then
						state <= done;
					else
						state <= party2_state;
					end if;
					--OFL
					count2 <= count2 +1;
				
				when party3_state=>
					--NSL
					if (select_party='1') then
						state <= done;
					else
						state <= party3_state;
					end if;
					--OSL
					count3 <= count3 +1;
					
				when done =>
					--NSL
					state <= initial;
					--OFL
				
				when others=>
					state <= initial;
				
			end case;
					
		end if;
	end if;
end process;

count1_op <= count1;
count2_op <= count2;
count3_op <= count3;

end Behavioral;

