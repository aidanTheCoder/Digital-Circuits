--multilevel circuits
library ieee;
use ieee.std_logic_1164.all;

entity vhdl_hw11 is
	port (a, b, c, d: in std_logic;
		y, z: out std_logic);
end entity;

architecture vhdl_hw11_arch of vhdl_hw11 is
	signal net8, net7, net6, net5, net4, net3, net2, net1, net0: std_logic;
begin
	net7 <= a or b;
	net6 <= not b;
	net5 <= c and d;
	net4 <= not d;
	net3 <= net8 and net7;
	net2 <= b;
	net1 <= net3 nor net2;
	net0 <= net5 and net4;
	y <= net0;
	z <= net1 or net0;
end architecture;