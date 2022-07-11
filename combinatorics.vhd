--BLXOR Blinking exclusive OR
--input 2 slide switches on DE-10
--whens switches are at different settings,
--blink LED 3x per second
--output switch state on respective LEDs

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity appendixc is
	port (clk : in std_logic; --50 mHz clock
			A,B : in std_logic; --2 switches in
			Aout,Bout : out std_logic; --switches out
			Z : out std_logic); --LED to blink
end entity;

architecture appendixc_arch of appendixc is
	signal counter : std_logic_vector(24 downto 0);
begin
	process(clk) --clk is 50 mHz
begin
	if rising_edge(clk) then counter <= counter + 1; --on 50 mHz clk edge
	end if;														 --override operation
	end process;												 --creates a counter
	Z <= (A xor B) and counter(24);						 --50mHz/(2**24)~1.5Hz
	Aout <= A;													 --exclusive OR logic
	Bout <= B;													 --echo switch state
end architecture;