--Sort No. 254
--CEC220 Digital Circuit Design
--Section 04PC
--Homework 19.2

library ieee;
use ieee.std_logic_1164.all;

entity hw19_part2 is
	port(d,clk,rst: in std_logic;
					 q: out std_logic);
end entity;

architecture hw19_part2_arch of hw19_part2 is
	begin
		dflipflop: process (d,clk)
	begin
		if clk='1' then q<=d;
		elsif rst='1' then q<='0';
		end if;
		end process;
end architecture;