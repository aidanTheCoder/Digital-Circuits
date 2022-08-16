--Sort No. 254
--cec220 digital circuit design
--homework 21, generic statements
--13 november 2019

library ieee;
use ieee.std_logic_1164.all;

entity hw21 is
	generic (m : positive := 4);
	port (clk,rst,ld_shift,serial_in : in std_logic;
			i : std_logic_vector(3 downto 0);
			q : inout std_logic_vector(m-1 downto 0);
			serial_out : out std_logic);
end entity;

architecture hw21_arch of hw21 is
	component dff1
		port (d,rst,clk : in std_logic;
				q : out std_logic);
	end component;
	signal temp : std_logic_vector(m-1 downto 0);
begin
	q <= temp;
	dff1_1 : dff1 port map (clk => clk,
									rst => rst,
									d => (i(1) and not ld_shift) or (ld_shift and serial_in),
									q => temp(m-1));
	hw211 : for index in m-1 downto 1 generate
		dff1_0 : dff1 port map (clk => clk,
										rst => rst,
										d => temp(index),
										q => temp(index-1));
	end generate;
end architecture;