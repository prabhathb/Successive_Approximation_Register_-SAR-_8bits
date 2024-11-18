library ieee;
use ieee.std_logic_1164.all;

entity sar is
	port(
		comparator_in: IN std_logic;
		clk: IN std_logic;
		reset: IN std_logic;
		dac_reg: INOUT std_logic_vector(7 downto 0);
		done: OUT std_logic;
		sar_output: OUT std_logic_vector(7 downto 0)
	);
end entity;

architecture behavioural_01 of sar is 

	type state_type is (s_init,s_7,s_6,s_5,s_4,s_3,s_2,s_1,s_0,s_done);
	signal state: state_type;

begin
	state_transition: process (clk,reset)
	begin
		if (reset = '0') then
			state <= s_init;
			dac_reg <= "00000000";
			sar_output <= "00000000";
			done <= '0';
		elsif (rising_edge(clk)) then 
			case state is
				when s_init =>
					state <= s_7;
						  --abcdefgh
					dac_reg <= "10000000";--set bit 7
					done <= '0';
				when s_7 =>
					state <= s_6;
					if (comparator_in = '1') then
							  --abcdefgh
						dac_reg <= dac_reg XOR "01000000";--set bit 6
					else
							  --abcdefgh
						dac_reg <= dac_reg XOR "11000000";--clear bit 7 and set bit 6
					end if;
				when s_6 =>
					state <= s_5;
					if (comparator_in = '1') then
							  --abcdefgh
						dac_reg <= dac_reg XOR "00100000";--set bit 5
					else
								      --abcdefgh
						dac_reg <= dac_reg XOR "01100000";--clear bit 6 and set bit 5
					end if;
				when s_5 =>
					state <= s_4;
					if (comparator_in = '1') then
								      --abcdefgh
						dac_reg <= dac_reg XOR "00010000";--set bit 4
					else
								      --abcdefgh
						dac_reg <= dac_reg XOR "00110000";--clear bit 5 and set bit 4
					end if;
				when s_4 =>
					state <= s_3;
					if (comparator_in = '1') then
								      --abcdefgh
						dac_reg <= dac_reg XOR "00001000";--set bit 3
					else
								      --abcdefgh
						dac_reg <= dac_reg XOR "00011000";--clear bit 4 and set bit 3
					end if;
				when s_3 =>
					state <= s_2;
					if (comparator_in = '1') then
								      --abcdefgh
						dac_reg <= dac_reg XOR "00000100";--set bit 2
					else
								      --abcdefgh
						dac_reg <= dac_reg XOR "00001100";--clear bit 3 and set bit 2
					end if;
				when s_2 =>
					state <= s_1;
					if (comparator_in = '1') then
								      --abcdefgh
						dac_reg <= dac_reg XOR "00000010";--set bit 1
					else
								      --abcdefgh
						dac_reg <= dac_reg XOR "00000110";--clear bit 2 and set bit 1
					end if;
				when s_1 =>
					state <= s_0;
					if (comparator_in = '1') then
								      --abcdefgh
						dac_reg <= dac_reg XOR "00000001";--set bit 0
					else
								      --abcdefgh
						dac_reg <= dac_reg XOR "00000011";--clear bit 1 and set bit 0
					end if;
				when s_0 =>
					state <= s_done;
					if (comparator_in = '1') then
								      --abcdefgh
						dac_reg <= dac_reg XOR "00000000";--set bit 0
					else
								      --abcdefgh
						dac_reg <= dac_reg XOR "00000001";--clear bit 0 
					end if;
				when s_done =>
						state <= s_init;
			         			  --abcdefgh
						sar_output <= dac_reg;
						dac_reg <= "00000000";
						done <= '1';
			end case;
		end if;
	end process state_transition;
end architecture;


