--sort no. 254
--digital circuit design cec220 section 04pc
--25 November 2019
--homework 24 Moore machine
library ieee;
use ieee.std_logic_1164.all;
entity hw24_part1 is
	port (i,clk,rst : in std_logic;
			z : out std_logic);
end entity;
architecture hw24_part1_arch of hw24_part1 is
	type stateType is (s0,s1,s2,s3,s4);
	signal sPres,sNext : stateType;
begin
	trans : process(clk,rst)
begin
	if rst = '1' then sPres <= s0;
	elsif rising_edge(clk) then sPres <= sNext;
	end if;
end process;
	behavior : process(i,sPres)
begin
	case sPres is
		when s0 =>
			if i = '1' then sNext <= s1;
							    z <= '0';
			else
				sNext <= s0;
				z <= '0';
			end if;
		when s1 =>
			if i = '0' then sNext <= s2;
								 z <= '0';
			else
				sNext <= s1;
				z <= '0';
			end if;
		when s2 =>
			if i = '1' then sNext <= s3;
								 z <= '0';
			else
				sNext <= s0;
				z <= '0';
			end if;
		when s3 =>
			if i = '1' then sNext <= s4;
								 z <= '0';
			else
				sNext <= s0;
				z <= '0';
			end if;
		when s4 =>
			if i = '1' then sNext <= s1;
								 z <= '1';
			else
				sNext <= s0;
				z <= '1';
			end if;
		when others =>
			sNext <= s0;
			    z <= '0';
	end case;
end process;
end architecture;
		
						
