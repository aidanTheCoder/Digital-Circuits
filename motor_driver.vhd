--rotary lab13, cec222
--input = 3 phase rotary switch output = 2 digit 7 segment display
--switch has no stops. Advanced output on each switch "click"
--output is limited between 0 and 99. Initial output = 50.
--follow schmematic in manual; duplicate discrete logic

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rotary is
	port (fast_clk : in std_logic;							 --50 mHz clock from DE-10 board
			      sw : in std_logic_vector(2 downto 0);	 --switches from the DE-10 board
			   sseg0 : out std_logic_vector(7 downto 0);  --1st 7 segment display
			   sseg1 : out std_logic_vector(7 downto 0)); --2nd 7 segment display
end entity;

architecture rotary_arch of rotary is
	signal clk : std_logic;									   --clock on DE-10
	signal clk_divider : std_logic_vector(5 downto 0); --clock divider
	signal rs0,rs1,rs2 : std_logic;							--resets for different states
	signal nrs0,nrs1,nrs2 : std_logic;						--output for reset
	signal drs0,drs1,drs2 : std_logic;						--D flip flops to debounce signals
	signal ds0,ds1,ds2 : std_logic;							--previous switch position
	signal s0,s1,s2 : std_logic;								--current switch position
	signal up,dn : std_logic;									--determines which way the switch is rotating
	signal up_clk,dn_clk : std_logic;						--up and down clock on counters
	signal v00,v99 : boolean;									--for when the counter reaches all 0's or > 99
	signal c0 : std_logic_vector(3 downto 0) := x"0";	--74192 counter
	signal c1 : std_logic_vector(3 downto 0) := x"5";	--2nd 74192 counter, both counters make an 8 bit counter
begin
	clkdiv : process(fast_clk) is				
begin
	if rising_edge(fast_clk) then 
		clk_divider <= clk_divider + 1; end if; 
end process;

clk <= clk_divider(5); --slows down the clock so the code doesn't lag behind the clock on board

rs0 <= sw(0) nand nrs0;	--Turns state to logic 1 when hit, others turn to logic 0
nrs0 <= rs0 nand (rs2 nor rs1);

rs1 <= sw(1) nand nrs1;	--Turns state to logic 1 when hit, others turn to logic 0
nrs1 <= rs1 nand (rs2 nor rs0);

rs2 <= sw(2) nand nrs2;	--Turns state to logic 1 when hit, others turn to logic 0
nrs2 <= rs2 nand (rs0 nor rs1);

shift_regs : process(clk) is
begin
	if (rising_edge(clk)) then
		drs0 <= rs0; drs1 <= rs1; drs2 <= rs2;
		ds0 <= not drs0; ds1 <= not drs1; ds2 <= not drs2;
	end if;
end process;

s0 <= drs0 and ds0; --stores the previous switch setting and resets
s1 <= drs1 and ds1; --stores the previous switch setting and resets
s2 <= drs2 and ds2; --stores the previous switch setting and resets

dn <= (s0 and ds1) or (s1 and ds2) or (s2 and ds0); --direction counter will count
up <= (s0 and ds2) or (s1 and ds0) or (s2 and ds1); --direction counter will count

v00 <= (c1 = x"0") and (c0 = x"0");							 --determines that current count is 0
v99 <= (c1 > x"9") or ((c1 = x"9") and (c0 >= x"99")); --determines that current count >= 99
dn_clk <= '0' when v00 else dn;
up_clk <= '0' when v99 else up;

dec_count : process(clk) is						 --process for keepign counter in range 00 < count value < 99
begin
	if (rising_edge(clk)) then
		if (c0 > x"9") then c0 <= x"9"; end if; --sets counter to not go higher than 99
		if (c1 > x"9") then c1 <= x"9"; end if; --sets counter to not go higher than 99
		
		if (up_clk = '1') then
			if (c0 < x"9") then c0 <= c0 + 1;
			else
				c0 <= x"0";
				if (c1 < x"9") then c1 <= c1 + 1; 
				end if;
			end if;
		end if;
		
		if (dn_clk = '1') then
			if (c0 > x"0") then c0 <= c0 - 1;
			else
				c0 <= x"9";
				if (c1 > x"0") then c1 <= c1 - 1; end if;
			end if;
		end if;
	end if;
end process;

with c0 select --selects output form counter, displays associated value on 7 segment display
	sseg0 <= "11000000" when x"0",
				"11111001" when x"1",
				"10100100" when x"2",
				"10110000" when x"3",
				"10011001" when x"4",
				"10010010" when x"5",
				"10000010" when x"6",
				"11111000" when x"7",
				"10000000" when x"8",
				"10011000" when x"9",
				"01111111" when others;
				
with c1 select --selects output form counter, displays associated value on 7 segment display
	sseg1 <= "11000000" when x"0",
				"11111001" when x"1",
				"10100100" when x"2",
				"10110000" when x"3",
				"10011001" when x"4",
				"10010010" when x"5",
				"10000010" when x"6",
				"11111000" when x"7",
				"10000000" when x"8",
				"10011000" when x"9",
				"01111111" when others;
end architecture;