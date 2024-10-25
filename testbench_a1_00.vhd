------------------------------------------------------
-- Ce programme a été développé à CENTRALE-SUPELEC
-- Merci de conserver ce cartouche
-- Copyright  (c) 2022  CENTRALE-SUPELEC   
-- Département Systèmes électroniques
-- --------------------------------------------------
--
-- fichier : testbench_a1_00.vhd
-- auteur  : P.BENABES   
-- Copyright (c) 2022 CENTRALE-SUPELEC
-- Revision: 4.1  Date: 22/02/2022
--
-- --------------------------------------------------
-- --------------------------------------------------
--
-- DESCRIPTION DU SCRIPT :
-- description du testbench incluant le testeur et le circuit
-- en mode route_io=0 multialim=0
-- pour la technologie XFAB 180 nm
--
--------------------------------------------------------

architecture schematic of testbench is


signal      clk1,clk2	: std_logic ; -- horloge du systeme
signal      raz	: std_logic ;
signal      enable,enable2	: std_logic ; -- signal a mesurer
signal      c2		: std_logic_vector(3 downto 0) ;
signal      c1,c0	: std_logic_vector(3 downto 0) ; 
signal      scan_in  :  std_logic  :='0' ;
signal      scan_out  :  std_logic  :='0';
signal      scan_clk  :  std_logic  :='0';
signal      scan_mode  :  std_logic  :='0';
signal      scan_enab  :  std_logic :='0' ;

COMPONENT fft16 IS
    GENERIC( nbit : integer :=12 );
    PORT( x : in tab16 ;
		  z : out tab9);
END COMPONENT fft16;

signal x : tab16;
signal z : tab9;

begin

  -- instantiation du systeme a tester  
  UUT : fft16  port map(x,z);     

  gene : process 
  begin
	for k in integer range 0 to 8 loop		-- pour les 8 frequences
		for l in integer range 0 to 15 loop
			x(l) <= to_sfixed(cos(real(l)*real(k)*math_pi/8.0)*0.99,vecteurin'left,vecteurin'right) ;
		end loop ;
		wait for 1 us ;
	end loop ;
  end process ;
end schematic;

