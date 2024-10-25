-- author: benabes
-- Library : work
-- Package : TYPES

library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_float_types.all;
use IEEE.fixed_pkg.all;


PACKAGE TYPES IS

  subtype vecteurin is sfixed(0 downto -11);          -- valeur signee codee sur 12 bits
  subtype vecteurc  is sfixed(1 downto -11);          -- valeur signee codee sur 12 bits

  type tab16 is array(0 to 15) of vecteurin;  
  type tab9 is array(0 to 8) of vecteurin;  
  type tab4 is array(0 to 3) of vecteurin;  
  type tab9u is array(0 to 8) of unsigned(7 downto 0);  
  
END TYPES;
