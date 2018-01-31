-- Test bench for atan implementation
-- Author: 
-- Date: 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity atan_tb is
end atan_tb;

architecture Behavioural of atan_tb is

	constant LEN : positive := 64;

	component atan is
	generic (
		G_LEN : natural := LEN
	);
	port (
		clk : in std_logic;
		rst : in std_logic;

		xin : in signed(LEN-1 downto 0);
		yin : in signed(LEN-1 downto 0);
		aout : out signed(LEN-1 downto 0);

		instrobe : in std_logic;
		outstrobe : out std_logic
	);

	end component atan;
    
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
	
	signal xin,yin,aout : signed(LEN-1 downto 0) := (others => '0');
	signal instrobe,outstrobe : std_logic := '0';

	-- type intarray is array (integer range <>) of integer;
	-- signal xs : intarray(0 to 360) := (255, 254, 254, 254, 254, 254, 253, 253, 252, 251, 251, 250, 249, 248, 247, 246, 245, 243, 242, 241, 239, 238, 236, 234, 232, 231, 229, 227, 225, 223, 220, 218, 216, 213, 211, 208, 206, 203, 200, 198, 195, 192, 189, 186, 183, 180, 177, 173, 170, 167, 163, 160, 156, 153, 149, 146, 142, 138, 135, 131, 127, 123, 119, 115, 111, 107, 103, 99, 95, 91, 87, 83, 78, 74, 70, 65, 61, 57, 53, 48, 44, 39, 35, 31, 26, 22, 17, 13, 8, 4, 0, -4, -8, -13, -17, -22, -26, -31, -35, -39, -44, -48, -53, -57, -61, -65, -70, -74, -78, -83, -87, -91, -95, -99, -103, -107, -111, -115, -119, -123, -127, -131, -135, -138, -142, -146, -149, -153, -156, -160, -163, -167, -170, -173, -177, -180, -183, -186, -189, -192, -195, -198, -200, -203, -206, -208, -211, -213, -216, -218, -220, -223, -225, -227, -229, -231, -232, -234, -236, -238, -239, -241, -242, -243, -245, -246, -247, -248, -249, -250, -251, -251, -252, -253, -253, -254, -254, -254, -254, -254, -255, -254, -254, -254, -254, -254, -253, -253, -252, -251, -251, -250, -249, -248, -247, -246, -245, -243, -242, -241, -239, -238, -236, -234, -232, -231, -229, -227, -225, -223, -220, -218, -216, -213, -211, -208, -206, -203, -200, -198, -195, -192, -189, -186, -183, -180, -177, -173, -170, -167, -163, -160, -156, -153, -149, -146, -142, -138, -135, -131, -127, -123, -119, -115, -111, -107, -103, -99, -95, -91, -87, -83, -78, -74, -70, -65, -61, -57, -53, -48, -44, -39, -35, -31, -26, -22, -17, -13, -8, -4, 0, 4, 8, 13, 17, 22, 26, 31, 35, 39, 44, 48, 53, 57, 61, 65, 70, 74, 78, 83, 87, 91, 95, 99, 103, 107, 111, 115, 119, 123, 127, 131, 135, 138, 142, 146, 149, 153, 156, 160, 163, 167, 170, 173, 177, 180, 183, 186, 189, 192, 195, 198, 200, 203, 206, 208, 211, 213, 216, 218, 220, 223, 225, 227, 229, 231, 232, 234, 236, 238, 239, 241, 242, 243, 245, 246, 247, 248, 249, 250, 251, 251, 252, 253, 253, 254, 254, 254, 254, 254, 255);
	-- signal ys : intarray(0 to 360) := (0, 4, 8, 13, 17, 22, 26, 31, 35, 39, 44, 48, 53, 57, 61, 65, 70, 74, 78, 83, 87, 91, 95, 99, 103, 107, 111, 115, 119, 123, 127, 131, 135, 138, 142, 146, 149, 153, 156, 160, 163, 167, 170, 173, 177, 180, 183, 186, 189, 192, 195, 198, 200, 203, 206, 208, 211, 213, 216, 218, 220, 223, 225, 227, 229, 231, 232, 234, 236, 238, 239, 241, 242, 243, 245, 246, 247, 248, 249, 250, 251, 251, 252, 253, 253, 254, 254, 254, 254, 254, 255, 254, 254, 254, 254, 254, 253, 253, 252, 251, 251, 250, 249, 248, 247, 246, 245, 243, 242, 241, 239, 238, 236, 234, 232, 231, 229, 227, 225, 223, 220, 218, 216, 213, 211, 208, 206, 203, 200, 198, 195, 192, 189, 186, 183, 180, 177, 173, 170, 167, 163, 160, 156, 153, 149, 146, 142, 138, 135, 131, 127, 123, 119, 115, 111, 107, 103, 99, 95, 91, 87, 83, 78, 74, 70, 65, 61, 57, 53, 48, 44, 39, 35, 31, 26, 22, 17, 13, 8, 4, 0, -4, -8, -13, -17, -22, -26, -31, -35, -39, -44, -48, -53, -57, -61, -65, -70, -74, -78, -83, -87, -91, -95, -99, -103, -107, -111, -115, -119, -123, -127, -131, -135, -138, -142, -146, -149, -153, -156, -160, -163, -167, -170, -173, -177, -180, -183, -186, -189, -192, -195, -198, -200, -203, -206, -208, -211, -213, -216, -218, -220, -223, -225, -227, -229, -231, -232, -234, -236, -238, -239, -241, -242, -243, -245, -246, -247, -248, -249, -250, -251, -251, -252, -253, -253, -254, -254, -254, -254, -254, -255, -254, -254, -254, -254, -254, -253, -253, -252, -251, -251, -250, -249, -248, -247, -246, -245, -243, -242, -241, -239, -238, -236, -234, -232, -231, -229, -227, -225, -223, -220, -218, -216, -213, -211, -208, -206, -203, -200, -198, -195, -192, -189, -186, -183, -180, -177, -173, -170, -167, -163, -160, -156, -153, -149, -146, -142, -138, -135, -131, -127, -123, -119, -115, -111, -107, -103, -99, -95, -91, -87, -83, -78, -74, -70, -65, -61, -57, -53, -48, -44, -39, -35, -31, -26, -22, -17, -13, -8, -4, 0);

	signal degreesin : integer := 0;
	signal degreesout : integer := 0;
	
    signal xin1 : std_logic_vector(63 downto 0) := X"0DE02C2E6B4A2D80";
    signal yin1 : std_logic_vector(63 downto 0) := X"003E00DF062B86B8";

begin

	clk <= 	not clk after 5 ns;
	
    uut: atan port map ( 
	
		xin => xin,
		yin => yin,
		aout => aout,

		clk => clk,
		rst => rst,
		instrobe => instrobe,
		outstrobe => outstrobe
	);
	
    test_proc : process
	
	variable i1 : integer := 0;
	variable r1 : real := 0.0;

    begin

			xin <= signed(xin1);
			yin <= signed(yin1);
            wait for 10 ns;
            	
		-- wait until rising_edge(clk);
		-- for i in 0 to 360 loop
			-- degreesin <= i;
			-- xin <= to_signed(integer(round(1000000000.0*cos(real(i)*MATH_PI/180.0))),LEN);
			-- yin <= to_signed(integer(round(1000000000.0*sin(real(i)*MATH_PI/180.0))),LEN);
			-- -- aout <= uut
			-- degreesout <= integer(round(real(to_integer(aout))*180.0/3.1415));
			-- wait for 10 ns;
		-- end loop;
		
		
        wait;
    end process test_proc;
end Behavioural;