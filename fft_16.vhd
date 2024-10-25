LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all;

entity fft16 is
   generic (nbit : integer :=12);
   port (clk : in std_logic;
			rst : in std_logic;
			x : in tab16;
			z : out tab9);
end entity;

architecture a1 of fft16 is
	component radix4 IS
		PORT(
			x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i  : IN vecteurin;	-- entres
			y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i	: OUT vecteurin;	-- sortie du radix
			d20,d21 									: IN std_logic
		);
	end component;
	
	component neda_weight is
		generic (i : integer;
		         n : integer);
		port (x0r : in vecteurin;
				x0i : in vecteurin;
				y0r : out vecteurin;
				y0i : out vecteurin);
	end component;
	
	constant sfixed_zero : vecteurin := to_sfixed(0, vecteurin'left, vecteurin'right);
	type t_radix_arr is array(0 to 3) of std_logic;
	constant d20_last_stage: t_radix_arr := ('1', '0', '0', '0');
	
	signal z_temp : tab9;
	signal x_div, x_reg, ar, ai, br, bi, br_shifted, bi_shifted, yr, yi : tab16;
begin
	-- Divide entry for Radix-4 first stage
	g_x_div: for i in 0 to 15 generate
		x_div(i) <= resize(shift_right(x(i), 2), vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
	end generate g_x_div;
	
	-- Input register stage
	process (clk, rst) is 
	begin
		if rst = '0' then
			x_reg <= (others => sfixed_zero);
		elsif rising_edge(clk) then
			x_reg <= x_div;
		end if;
	end process;
	
	-- Radix-4 first stage
	g_radix4_1: for i in 0 to 3 generate
		u_radix4_1: radix4
			port map(
				x0r => x_reg(i),
				x0i => sfixed_zero,
				x1r => x_reg(i+4),
				x1i => sfixed_zero,
				x2r => x_reg(i+8),
				x2i => sfixed_zero,
				x3r => x_reg(i+12),
				x3i => sfixed_zero,
				y0r => ar(i),
				y0i => ai(i),
				y1r => ar(i+4),
				y1i => ai(i+4),
				y2r => ar(i+8),
				y2i => ai(i+8),
				y3r => ar(i+12),
				y3i => ai(i+12),
				d20 => '1',
				d21 => '1');
	end generate g_radix4_1;
	
	-- Generate all 16 NEDA block
	g_NEDA_block1: for i in 0 to 3 generate
		g_NEDA_block2: for j in 0 to 3 generate
			u_neda: neda_weight
				generic map(
					i => i*j,
					n => 16
				)
				port map(
					x0r => ar(i+j*4),
					x0i => ai(i+j*4),
					y0r => br(i+j*4),
					y0i => bi(i+j*4)
				);
		end generate g_NEDA_block2;
	end generate g_NEDA_block1;
	
	-- Radix-4 last stage
	g_b_div: for i in 0 to 15 generate
		br_shifted(i) <= resize(shift_right(br(i), 1), vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
		bi_shifted(i) <= resize(shift_right(bi(i), 1), vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
	end generate g_b_div;
	
	g_radix4_2: for i in 0 to 3 generate
		u_radix4_2: radix4
			port map(
				x0r => br_shifted(i*4),
				x0i => bi_shifted(i*4),
				x1r => br_shifted(i*4+1),
				x1i => bi_shifted(i*4+1),
				x2r => br_shifted(i*4+2),
				x2i => bi_shifted(i*4+2),
				x3r => br_shifted(i*4+3),
				x3i => bi_shifted(i*4+3),
				y0r => yr(i),
				y0i => yi(i),
				y1r => yr(i+4),
				y1i => yi(i+4),
				y2r => yr(i+8),
				y2i => yi(i+8),
				y3r => yr(i+12),
				y3i => yi(i+12),
				d20 => d20_last_stage(i),
				d21 => '0');
	end generate g_radix4_2;
	
	g_norm: for i in 0 to 8 generate
		z_temp(i) <= shift_left(resize(yr(i)*yr(i) + yi(i)*yi(i), vecteurin'left, vecteurin'right, fixed_saturate, fixed_truncate), 2); -- TODO sqrt 
	end generate g_norm;
	
	-- Output register stage
	process (clk, rst) is 
	begin
		if rst = '0' then
			z <= (others => sfixed_zero);
		elsif rising_edge(clk) then
			z <= z_temp;
		end if;
	end process;
end a1;
