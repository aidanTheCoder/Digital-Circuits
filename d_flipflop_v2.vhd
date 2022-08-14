--Sort No. 254
--CEC220 Digital Circuit Design
--Section 04.PC
--Homework 20

library ieee;
use ieee.std_logic_1164.all;

entity hw20 is
    Port (rst, clk : in std_logic;
			  q : out std_logic_vector(2 downto 0));			
end entity;

architecture hw20_arch of hw20 is
signal qtemp,dtemp : std_logic_vector(2 downto 0);
component dff1
	port (d, rst, clk : in std_logic;
				 q : out std_logic);
end component;
begin
	dtemp(2) <= (not qtemp(2) and (qtemp(0) xor qtemp(1))) or (qtemp(0) and (qtemp(1)) and qtemp(2));
	dtemp(1) <= ((not qtemp(1)) and (not qtemp(2) or qtemp(0)));
	dtemp(0) <= ((not qtemp(2) and qtemp(0))) or ((qtemp(1) or (not qtemp(0))) and qtemp(2));
	q <= qtemp;
	dff1_2 : dff1 port map ( d => dtemp(2), rst => rst, clk => clk, q => qtemp(2));
	dff1_1 : dff1 port map ( d => dtemp(1), rst => rst, clk => clk, q => qtemp(1));
	dff1_0 : dff1 port map ( d => dtemp(0), rst => rst, clk => clk, q => qtemp(0));
end architecture;