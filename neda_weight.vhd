LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use ieee.math_real.all;
use work.types.all;

entity neda_weight is
   generic (i : integer := 0;
	         n : integer := 0);
   port (clk : in std_logic;
			x0r : in vecteurin;
	      x0i : in vecteurin;
			y0r : out vecteurin;
			y0i : out vecteurin);
end entity;

architecture a1 of neda_weight is
	type t_weight_arr is array(9 downto 1) of vecteurc;
	
	signal C_COS_WEIGHT : vecteurc := to_sfixed(cos(real(i)*MATH_PI/(real(n)/2.0)), vecteurc'left, vecteurc'right, fixed_wrap, fixed_truncate);
	signal C_SIN_WEIGHT : vecteurc := to_sfixed(sin(real(i)*MATH_PI/(real(n)/2.0)), vecteurc'left, vecteurc'right, fixed_wrap, fixed_truncate);
	
	signal sub_w0, sub_w1, sub_w2, sub_w3 : vecteurin;
begin
	
	-- If index of weight is zero then directly link int/out without adding logic
	g_index_zero : if i = 0 generate
		process (clk) is
		begin
			if rising_edge(clk) then
				sub_w0 <= x0r;
				sub_w1 <= x0i;
			end if;
		end process;
		
		y0r <= sub_w0;
		y0i <= sub_w1;
	end generate g_index_zero;
	
	-- Else apply weight to input
	g_nonzero : if (i > 0 and i <= 9) generate
		process (clk) is
		begin
			if rising_edge(clk) then
				sub_w0 <= resize(x0r*C_COS_WEIGHT, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
				sub_w1 <= resize(x0i*C_SIN_WEIGHT, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
				sub_w2 <= resize(x0i*C_COS_WEIGHT, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
				sub_w3 <= resize(x0r*C_SIN_WEIGHT, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
			end if;
		end process;
		
		y0r <= resize(sub_w0 + sub_w1, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
		y0i <= resize(sub_w2 - sub_w3, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
	end generate g_nonzero;
end a1;