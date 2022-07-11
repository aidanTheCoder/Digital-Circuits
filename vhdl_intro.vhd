library ieee;
use ieee.std_logic_1164.all;

entity cec222_vhdl_prelab8 is
	port (a,b,c,d: in std_logic;
			      k: inout std_logic;
			      z: out std_logic);
end entity;

architecture cec222_vhdl_prelab8_arch of cec222_vhdl_prelab8 is
	signal net9,net8,net7,net6,net5,net4,net3,net2,net1,net0: std_logic;
begin
		net9 <= not c;
		net8 <= not a;
		net7 <= net9 or d;
		net6 <= not c;
		net5 <= b xor d;
		net4 <= not d;
		net3 <= net8 or net7;
		net2 <= net5 or net6;
		net1 <= a and c and net4;
		   k <= net1 or net2 or net3;
end architecture;