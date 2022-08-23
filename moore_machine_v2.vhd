--sort no. 254
--digital circuit design cec220 section 04pc
--25 November 2019
--HW 24 Moore machine with sequential logic
library ieee;
use ieee.std_logic_1164.all;
entity hw24_part2 is
	port (i,rst,clk : in std_logic;
			z : out std_logic);
end entity;
architecture hw24_part2_arch of hw24_part2 is
	type stateType is (s0,s1,s2,s3,s4);
	signal sPres,sNext : stateType;
begin
	trans : process(clk,rst)
begin
	if rst = '1' then sPres <= s0;
	elsif rising_edge(clk) then sPres <= sNext;
	end if;
end process;
	sNext <= s1 when (i = '1' and sPres = s0) else
				s2 when (i = '0' and sPres = s1) else
				s3 when (i = '1' and sPres = s2) else
				s4 when (i = '1' and sPres = s3) else
				s1 when (i = '1' and sPres = s4) else
				s0 when (i = '0' and sPres = s4) else s0;
	with sPres select
		z <= '1' when s4,
		     '0' when others;
end architecture;