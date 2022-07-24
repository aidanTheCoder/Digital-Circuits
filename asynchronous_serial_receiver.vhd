--arx aysnchronous serial reciever CEC222 Lab12
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity arx is
	port (fast_clk : in std_logic;	 --50 mHz clock form DE-10
			     Din : in std_logic;	 --serial data from transmitter
				valid : inout std_logic; --signal all data recieved
			 pty_err : out std_logic;	 --parity check result
			    data : inout std_logic_vector(4 downto 0); --data reg = 4 bits plus parity
			  strobe : out std_logic);  --sample signal for scope test
end entity;

architecture arx_arch of arx is
	constant baud_rate : integer := 313;			 --clock divider to match transmitter * 8
	constant end_count : integer := 63*baud_rate; --max count per message
	 signal parity_bit : std_logic;					 --parity bit recorded form transmitter
	 signal timer : integer range 0 to end_count; --clock divider / counter
begin
	process(fast_clk) --divide 50 mHz down to given baud rate
begin
	if rising_edge(fast_clk) then
		if timer < end_count then timer <= timer + 1; --timer counts until end_count
		elsif Din = '1' then timer <= 0;					 --start bit -> start counting
		end if;
	case timer is
		when 10*baud_rate => valid   <= '0'; --signal that data & parity can't be interpreted yet
									data(0) <= Din; --capture bit 0 (originated at switch 1 of transmitter)
									strobe  <= '1'; --flag for testing
		when 11*baud_rate => strobe  <= '0';
		when 18*baud_rate => data(1) <= Din; --capture bit 1 (originated at switch 2 of transmitter)
									strobe  <= '1'; --flag for testing
		when 19*baud_rate => strobe  <= '0';
		when 26*baud_rate => data(2) <= Din; --capture bit 2 (originated at switch 3 of transmitter)
									strobe  <= '1'; --flag for testing
		when 27*baud_rate => strobe  <= '0';
		when 34*baud_rate => data(3) <= Din; --capture bit 3 (originated at switch 4 of transmitter)
									strobe  <= '1'; --flag for testing
		when 35*baud_rate => strobe  <= '0';
		when 42*baud_rate => parity_bit <= Din; --capture parity bit
									valid <= '1';      --data & parity bits OK to read
									strobe  <= '1';	 --flag for testing
		when 43*baud_rate => strobe  <= '0';
		when others => null;							 --sets default staements if no statement matches
		end case;
	end if;
end process;
pty_err <= valid and --computes odd parity
				 (not data(4) xor data(0) xor data(1) xor data(2) xor data(3));
end architecture;