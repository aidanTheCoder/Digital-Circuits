--Sort No. 254
--CEC220 Digital Circuit Design
--Section 04PC
--Homework 19.1

library ieee;
use ieee.std_logic_1164.all;

entity hw19_part1 is
	port(t,clk: in std_logic;
				q: out std_logic);
end entity;

architecture hw19_part1_arch of hw19_part1 is
	signal qtemp: std_logic := '0';
begin
	process (clk)
begin
		if t='0' then q<=qtemp;
		elsif T='1' then qtemp<=not qtemp;
		end if;
	end process;
end architecture;