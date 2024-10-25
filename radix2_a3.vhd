LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all;

ENTITY radix2 IS
	PORT(
		d2	: IN  std_logic;					-- indique si on doit diviser par 2
      x0 : IN  vecteurin;-- entree 1
      x1 : IN  vecteurin;	-- entree 2
      yp : OUT vecteurin;	-- sortie somme
		ym : OUT vecteurin	-- sortie difference
	);
END radix2;

architecture a3 of radix2 is

signal som, dif: sfixed(vecteurin'left+1 downto vecteurin'right);

begin
	som <= x0 + x1;
	dif <= x0 - x1;

	process (som,dif,d2)
	begin
		if (d2='0') then
			yp <= resize(som, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
			ym <= resize(dif, vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
		else
			yp <= resize(shift_right(som, 1), vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
			ym <= resize(shift_right(dif, 1), vecteurin'left, vecteurin'right, fixed_wrap, fixed_truncate);
		end if ;
	end process ;

end architecture a3;

