--brm - binary rate multiplier

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity brm is
	port(fast_clk : in std_logic; --50 mHz clock from DE-10
		reset: in std_logic; --push button resets counter
		enable : in std_logic; --slide switch unblanks BRM output
		rate : in std_logic_vector(7 downto 0); --sets BRM rate
		speed : in std_logic; --slide switch to pick clock speed
			
		q_out : out std_logic_vector(7 downto 0); --counter to scope
		q_led : out std_logic_vector(7 downto 0); --counter to LEDs
		brm_out : out std_logic --BRM to scope	
		brm_led : out std_logic; --BRM to LED 9
		carry : out std_logic; --sync scope
		cry_led : out std_logic; --blink LED 8 on carry
		motor : inout std_logic_vector(2 downto 0); --powers coils to drive motor
		key : in std_logic); --determines which way the motor spins
end entity;

architecture brm_arch of brm is
	constant clk_size : natural := 21; --size of local counter
	constant clk_delta : natural := 10; --difference between slow and fast_clk
	signal slow_clk : std_logic; --clock chosen be speed switch
	signal clk_divider : std_logic_vector(clk_zise downto 0);--clock divider
	signal q : std_logic_vector(7 downto 0); --brm counter
	signal f : std_logic_vector(7 downto 0) --minterm pulses
	signal brm : std_logic; --internal brm pulses
	
begin
process(fast_clk) --define process for fast clock
begin	
	if (rising_edge(fast_clk)) --when fast clock is on the rising edge
		then clk_divider <= clk_divider + 1; --increment clock divider
	end if; --end fast clock process
end process;

slow_clk <= clk_divider(clk_size) when speed = '0' --assigns speed of slow clock
else clk_divider(clk_size - clk_delta); --selects clock speed between slow and fast

process(slow_clk, reset)
begin
	if reset = '0' then q <= "00000000"; --resets brm to 0
		elsif rising_edge(slow_clk) then q <= q + 1; --increment q on rising edge of 
	end if; 									 	 --clock if brm is not reset
end process;

f(0) <= '1' when q = "01111111" else '0'; --minterm at f(#)
f(1) <= '1' when std_match (q, "-0111111") else '0';
f(2) <= '1' when std_match (q, "--011111") else '0';
f(3) <= '1' when std_match (q, "---01111") else '0';
f(4) <= '1' when std_match (q, "----0111") else '0';
f(5) <= '1' when std_match (q, "-----011") else '0';
f(6) <= '1' when std_match (q, "------01") else '0';
f(7) <= '1' when std_match (q, "-------0") else '0';

brm <= '1' when (f and rate) /= "00000000" else '0'; --brm works at this state
process(brm)
begin
	case key & motor is --process executes based off motor inputs
		when "0001" => motor <= "010"; --1st term sequence for clockwise spin
		when "0010" => motor <= "100"; --2nd term sequence for clockwise spin
		when "0100" => motor <= "001"; --3rd term sequence for clockwise spin
		when "1001" => motor <= "100"; --1st term sequence for counterclockwise
		when "1100" => motor <= "010"; --2nd term sequence for counterclockwise
		when "1010" => motor <= "001"; --3rd term sequence for counterclockwise
		when others => motor <= "100"; --default value for brm sequence drive
	end case;
end process;

q_out <= q; --connects scope counter to brm counter
q_led <= q; --connects LED counter to brm counter
brm_out <= brm and slow_clk and enable; --brm output
brm_led <= brm and slow_clk and enable; --brm output woth LEDs
cry_led <= '1' when q = "11111111" else '0'; --carry output that blinks led		
carry <= '1' when q = "11111111" else '0'; --causes 1 to carry over to next bit
end architecture;	