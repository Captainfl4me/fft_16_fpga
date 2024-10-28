LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;

ENTITY radix4 IS
    PORT(
		clk 											: in std_logic;
      x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i     : IN sfixed(vecteurin'range) ;	-- entres
		y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i	   : OUT sfixed(vecteurin'range) ;	-- sortie du radix
		d20,d21 									   : IN std_logic
    );
END radix4;

architecture a1 of radix4 is
	COMPONENT radix2 IS
		 PORT(
			d2	: IN  std_logic ;					-- indique si on doit diviser par 2
			x0 : IN  vecteurin ;-- entree 1
			x1 : IN  vecteurin;	-- entree 2
			yp : OUT vecteurin;	-- sortie somme
			ym : OUT vecteurin	-- sortie difference
		 );
	END COMPONENT;

	signal b0r, b0i, b1r, b1i, b2r, b2i, b3r, b3i : vecteurin;
	signal b0r_latched, b0i_latched, b1r_latched, b1i_latched, b2r_latched, b2i_latched, b3r_latched, b3i_latched : vecteurin;
begin
	URAD2_1r: radix2
		port map(
			d2 => '0',
			x0 => x0r,
			x1 => x2r,
			yp => b0r,
			ym => b1r
		);		
	URAD2_1i: radix2
		port map(
			d2 => '0',
			x0 => x0i,
			x1 => x2i,
			yp => b0i,
			ym => b1i
		);
		
	URAD2_2r: radix2
		port map(
			d2 => '0',
			x0 => x1r,
			x1 => x3r,
			yp => b2r,
			ym => b3r
		);
	URAD2_2i: radix2
		port map(
			d2 => '0',
			x0 => x1i,
			x1 => x3i,
			yp => b2i,
			ym => b3i
		);
		
	process (clk) is
	begin
		if rising_edge(clk) then
			b0r_latched <= b0r;
			b0i_latched <= b0i;
			b1r_latched <= b1r;
			b1i_latched <= b1i;
			b2r_latched <= b2r;
			b2i_latched <= b2i;
			b3r_latched <= b3r;
			b3i_latched <= b3i;
		end if;
	end process;
		
	URAD2_3r: radix2
		port map(
			d2 => d20,
			x0 => b0r_latched,
			x1 => b2r_latched,
			yp => y0r,
			ym => y2r
		);
	URAD2_3i: radix2
		port map(
			d2 => d20,
			x0 => b0i_latched,
			x1 => b2i_latched,
			yp => y0i,
			ym => y2i
		);
		
	URAD2_4r: radix2
		port map(
			d2 => d21,
			x0 => b1r_latched,
			x1 => b3i_latched,
			yp => y1r,
			ym => y3r
		);
	URAD2_4i: radix2
		port map(
			d2 => d21,
			x0 => b1i_latched,
			x1 => b3r_latched,
			yp => y3i,
			ym => y1i
		);
end architecture a1;

