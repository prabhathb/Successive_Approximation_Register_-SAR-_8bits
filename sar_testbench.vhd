library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity sar_testbench is
	--empty
end entity;


architecture tb1 of sar_testbench is
	-- define the constants used
	constant clock_period: time := 10 ps;

	-- declare the componenet/DUT (Device Under Test) used for the test
	component sar is
		port(
			comparator_in: IN std_logic;
			clk: IN std_logic;
			reset: IN std_logic;
			dac_reg: INOUT std_logic_vector(7 downto 0);
			done: OUT std_logic;
			sar_output: OUT std_logic_vector(7 downto 0)
		);
	end component;

	-- bind the component to be used for test
	for all: sar use entity work.sar(behavioural_01);

	-- declare the signals useed by the DUT
	signal comparator_in: std_logic := '0';
	signal clk: std_logic := '0';
	signal reset: std_logic := '1';
	signal dac_reg: std_logic_vector(7 downto 0) := "00000000";
	signal done: std_logic := '0';
	signal sar_output: std_logic_vector(7 downto 0) := "00000000";
	-- this signal produces the input bit sequences coming from the comparator
	signal pattern: std_logic_vector(7 downto 0) := "00000000";
	-- this is used for the assert expression
	signal old_pattern: std_logic_vector(7 downto 0) := "00000000";

begin
	-- instantiate the component to be tested
	u0: sar port map(comparator_in,clk,reset,dac_reg,done,sar_output);

	-- process rst
	-- this process generates and maintains the reset signal to the DUT
	rst: process
	begin
		wait until rising_edge(clk);
		reset <= '0';
		wait for clock_period/4;
		reset <= '1';
		wait;
	end process rst;

	-- process clock
	-- this process generates the clock signal in the desired pattern
	clock: process
	begin
		clk <= '0';
		wait for clock_period/2;
		clk <= '1';
		wait for clock_period/2;
	end process clock;

	-- process simulation
	-- this process generates the sequences of comparator input bit patterns
	-- for all possible input voltages and apply those bit patterns one bit
	-- at a time simulating the actual process takes place in SAR.
	simulation: process
	begin
		wait until rising_edge(clk);
		for j in 0 to 255 loop
			pattern <= std_logic_vector(to_unsigned(j,pattern'length));
			comparator_in <=  '-';
			wait until rising_edge(clk);--s_init
			comparator_in <=  pattern(7);
			wait until rising_edge(clk);--s_7
			comparator_in <=  pattern(6);
			wait until rising_edge(clk);--s_6
			comparator_in <=  pattern(5);
			wait until rising_edge(clk);--s_5
			comparator_in <=  pattern(4);
			wait until rising_edge(clk);--s_4
			comparator_in <=  pattern(3);
			wait until rising_edge(clk);--s_3
			comparator_in <=  pattern(2);
			wait until rising_edge(clk);--s_2
			comparator_in <=  pattern(1);
			wait until rising_edge(clk);--s_1
			comparator_in <=  pattern(0);
			wait until rising_edge(clk);--s_0
			comparator_in <=  '-';
			wait until rising_edge(clk);--s_done
			old_pattern <= pattern;
		end loop;
	end process simulation;

	-- process error_reporting
	-- this process reports the mismatches of the input comparator bit sequence and
	-- the output of the SAR.
	-- that pair of values are also written to a textfile.
	error_reporting: process

	-- input comparator sequence and SAR output will be written to a text file.
	-- for test purpose only.
	variable line_out : line;
	file out_file : text open write_mode is "E:\ModelSim Projects\VHDL\ModelSim Projects\SAR 2024\out_file.txt"; -- file path
	begin

		-- assert and report and error in case the input comparator bit sequence and the SAR output do not match
		-- for test purpose only.
		wait until done = '1';	-- indicates the conversion is DONE and output is ready.
		assert sar_output = old_pattern
		report "Unexpected result: sar_output = " & integer'image(to_integer(unsigned(sar_output))) & "; " &
			"old_patten = " & integer'image(to_integer(unsigned(old_pattern))) & ";"
		severity error;
			-- generate the text to be wriiten to the file.
		write(line_out, integer'image(to_integer(unsigned(sar_output))) & ", ");
		write(line_out, integer'image(to_integer(unsigned(old_pattern))));
		writeline(out_file, line_out);	-- write the text line to the file.
	end process error_reporting;
end architecture;
