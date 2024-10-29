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
			load_data: in std_logic;
			x : in tab16;
			z : out tab9);
end entity;

architecture a1 of fft16 is
	component radix4 IS
		PORT(
			clk 										: in std_logic;
			x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i  : IN vecteurin;	-- entres
			y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i	: OUT vecteurin;	-- sortie du radix
			d20,d21 									: IN std_logic
		);
	end component;
	
	component neda_weight is
		generic (i : integer;
		         n : integer);
		port (clk : in std_logic;
				x0r : in vecteurin;
				x0i : in vecteurin;
				y0r : out vecteurin;
				y0i : out vecteurin);
	end component;
	
	constant sfixed_zero : vecteurin := to_sfixed(0, vecteurin'left, vecteurin'right);
	type t_radix_arr is array(0 to 3) of std_logic;
	constant d20_last_stage: t_radix_arr := ('1', '0', '0', '0');
	
	signal yr_sqr, yi_sqr : tab9;
	signal x_reg, ar, ai, ar_sync, ai_sync, br, bi, br_latched, bi_latched, yr, yi, yr_sync, yi_sync : tab16;
begin	
	-- Input register stage
	process (clk, rst) is 
	begin
		if rst = '0' then
			x_reg <= (others => sfixed_zero);
		elsif rising_edge(clk) and load_data = '1' then
			x_reg <= x;
		end if;
	end process;
	
	-- Radix-4 first stage
	g_radix4_1: for i in 0 to 3 generate
		u_radix4_1: radix4
			port map(
				clk => clk,
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
	
	-- D-latch block
	process (clk, rst) is 
	begin
		if rising_edge(clk) then
			ar_sync <= ar;
			ai_sync <= ai;
		end if;
	end process;
	
	-- Generate all 16 NEDA block
	g_NEDA_block1: for i in 0 to 3 generate
		g_NEDA_block2: for j in 0 to 3 generate
			u_neda: neda_weight
				generic map(
					i => i*j,
					n => 16
				)
				port map(
					clk => clk,
					x0r => ar_sync(i+j*4),
					x0i => ai_sync(i+j*4),
					y0r => br(i+j*4),
					y0i => bi(i+j*4)
				);
		end generate g_NEDA_block2;
	end generate g_NEDA_block1;
	
	-- Radix-4 last stage with D-latch
	process (clk) is 
	begin
		if rising_edge(clk) then
			for i in 0 to 15 loop
				br_latched(i) <= br(i);
				bi_latched(i) <= bi(i);
			end loop;
		end if;
	end process;
	
	g_radix4_2: for i in 0 to 3 generate
		u_radix4_2: radix4
			port map(
				clk => clk,
				x0r => br_latched(i*4),
				x0i => bi_latched(i*4),
				x1r => br_latched(i*4+1),
				x1i => bi_latched(i*4+1),
				x2r => br_latched(i*4+2),
				x2i => bi_latched(i*4+2),
				x3r => br_latched(i*4+3),
				x3i => bi_latched(i*4+3),
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
	
	process (clk) is 
	begin
		if rising_edge(clk) then
			yr_sync <= yr;
			yi_sync <= yi;
		end if;
	end process;
	
	-- D-latch between abs computation
	process (clk) is
	begin
		if rising_edge(clk) then
			for i in tab9'range loop
				yr_sqr(i) <= resize(yr_sync(i)*yr_sync(i), vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
				yi_sqr(i) <= resize(yi_sync(i)*yi_sync(i), vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
			end loop;
		end if;
	end process;
	
	-- Output register stage
	process (clk) is
	begin
		if rising_edge(clk) then
			for i in tab9'range loop
				z(i) <= resize(yr_sqr(i) + yi_sqr(i), vecteurin'left, vecteurin'right, fixed_saturate, fixed_truncate);
			end loop;
		end if;
	end process;
end a1;
