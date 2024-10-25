LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;

ENTITY radix4 IS
    PORT(
      x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i     : IN sfixed(vecteurin'range) ;	-- entres
		y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i	   : OUT sfixed(vecteurin'range) ;	-- sortie du radix
		d20,d21 									   : IN std_logic
    );
END radix4;
