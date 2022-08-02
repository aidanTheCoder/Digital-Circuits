--sort. No
--CEC220 04.PC Digital Circuit Design
--October 4, 2019
--Demultiplexers in VHDL

library ieee;
use ieee.std_logic_1164.all;

entity hw13part1 is
	port ( i : in std_logic_vector(7 downto 0);
			 s : in std_logic_vector(2 downto 0);
			 f : out std_logic);
end entity;

architecture hw13part1_arch of hw13part1 is
	begin
		f <= i(0) when ( s= "000" ) else
			  i(1) when ( s= "001" ) else
			  i(2) when ( s= "010" ) else
			  i(3) when ( s= "011" ) else
			  i(4) when ( s= "100" ) else
			  i(5) when ( s= "101" ) else
			  i(6) when ( s= "110" ) else
			  i(7) when ( s= "111" );
end architecture;