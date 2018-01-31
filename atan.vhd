library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity atan is
	generic (
		G_LEN : natural
	);
	port (
		clk : in std_logic;
		rst : in std_logic;

		xin : in signed(G_LEN-1 downto 0);
		yin : in signed(G_LEN-1 downto 0);
		aout : out signed(G_LEN-1 downto 0);

		instrobe : in std_logic;
		outstrobe : out std_logic
	);
end entity atan;

architecture behavioral of atan is

	-- internal length... this seems to work...
	constant LEN : natural := G_LEN+2;
	
	-- list of 64 bit angles (in radians) of 1e18*atan(1/2^n) n=0,1,2...
	-- [785398163397448320 463647609000806080 244978663126864128 124354994546761440 62418809995957352 31239833430268276 15623728620476832 7812341060101111 3906230131966972 1953122516478818 976562189559319 488281211194898 244140620149361 122070311893670 61035156174208 30517578115526 15258789061315 7629394531101 3814697265606 1907348632810 953674316405 476837158203 238418579101 119209289550 59604644775 29802322387 14901161193 7450580596 3725290298 1862645149 931322574 465661287 232830643 116415321 58207660 29103830 14551915 7275957 3637978 1818989 909494 454747 227373 113686 56843 28421 14210 7105 3552 1776 888 444 222 111 55 27 13 6 3 1 0]
  type mem is array ( Integer range <> ) of signed(LEN-1 downto 0);
  constant angles : mem := (
  -- code_generator.go
0 => resize( X"0AE64B77E88C9280", LEN),
1 => resize( X"066F350B3B73C6C0", LEN),
2 => resize( X"036656CBD13A1100", LEN),
3 => resize( X"01B9CC356C015EE0", LEN),
4 => resize( X"00DDC193B51C9468", LEN),
5 => resize( X"006EFC7686741974", LEN),
6 => resize( X"003781B2CA7D99A0", LEN),
7 => resize( X"001BC14865C063F7", LEN),
8 => resize( X"000DE0B2136D43FC", LEN),
9 => resize( X"0006F05AC5CC2B62", LEN),
10 => resize( X"0003782D9A68E617", LEN),
11 => resize( X"0001BC16D424CE12", LEN),
12 => resize( X"0000DE0B6AF07271", LEN),
13 => resize( X"00006F05B593FAA6", LEN),
14 => resize( X"00003782DACD7580", LEN),
15 => resize( X"00001BC16D6729C6", LEN),
16 => resize( X"00000DE0B6B3A2C3", LEN),
17 => resize( X"000006F05B59D31D", LEN),
18 => resize( X"000003782DACE9C6", LEN),
19 => resize( X"000001BC16D674EA", LEN),
20 => resize( X"000000DE0B6B3A75", LEN),
21 => resize( X"0000006F05B59D3B", LEN),
22 => resize( X"0000003782DACE9D", LEN),
23 => resize( X"0000001BC16D674E", LEN),
24 => resize( X"0000000DE0B6B3A7", LEN),
25 => resize( X"00000006F05B59D3", LEN),
26 => resize( X"00000003782DACE9", LEN),
27 => resize( X"00000001BC16D674", LEN),
28 => resize( X"00000000DE0B6B3A", LEN),
29 => resize( X"000000006F05B59D", LEN),
30 => resize( X"000000003782DACE", LEN),
31 => resize( X"000000001BC16D67", LEN),
32 => resize( X"000000000DE0B6B3", LEN),
33 => resize( X"0000000006F05B59", LEN),
34 => resize( X"0000000003782DAC", LEN),
35 => resize( X"0000000001BC16D6", LEN),
36 => resize( X"0000000000DE0B6B", LEN),
37 => resize( X"00000000006F05B5", LEN),
38 => resize( X"00000000003782DA", LEN),
39 => resize( X"00000000001BC16D", LEN),
40 => resize( X"00000000000DE0B6", LEN),
41 => resize( X"000000000006F05B", LEN),
42 => resize( X"000000000003782D", LEN),
43 => resize( X"000000000001BC16", LEN),
44 => resize( X"000000000000DE0B", LEN),
45 => resize( X"0000000000006F05", LEN),
46 => resize( X"0000000000003782", LEN),
47 => resize( X"0000000000001BC1", LEN),
48 => resize( X"0000000000000DE0", LEN),
49 => resize( X"00000000000006F0", LEN),
50 => resize( X"0000000000000378", LEN),
51 => resize( X"00000000000001BC", LEN),
52 => resize( X"00000000000000DE", LEN),
53 => resize( X"000000000000006F", LEN),
54 => resize( X"0000000000000037", LEN),
55 => resize( X"000000000000001B", LEN),
56 => resize( X"000000000000000D", LEN),
57 => resize( X"0000000000000006", LEN),
58 => resize( X"0000000000000003", LEN),
59 => resize( X"0000000000000001", LEN),
60 => resize( X"0000000000000000", LEN)
);

	-- initialize vars to signed(LEN-1 downto 0) := (others => '0');
	-- code_generator.go
	signal x0,y0,a0, x1,y1,a1, x2,y2,a2, x3,y3,a3, x4,y4,a4, x5,y5,a5, x6,y6,a6, x7,y7,a7, x8,y8,a8, x9,y9,a9, x10,y10,a10, x11,y11,a11, x12,y12,a12, x13,y13,a13, x14,y14,a14, x15,y15,a15, x16,y16,a16, x17,y17,a17, x18,y18,a18, x19,y19,a19, x20,y20,a20, x21,y21,a21, x22,y22,a22, x23,y23,a23, x24,y24,a24, x25,y25,a25, x26,y26,a26, x27,y27,a27, x28,y28,a28, x29,y29,a29, x30,y30,a30, x31,y31,a31, x32,y32,a32, x33,y33,a33, x34,y34,a34, x35,y35,a35, x36,y36,a36, x37,y37,a37, x38,y38,a38, x39,y39,a39, x40,y40,a40, x41,y41,a41, x42,y42,a42, x43,y43,a43, x44,y44,a44, x45,y45,a45, x46,y46,a46, x47,y47,a47, x48,y48,a48, x49,y49,a49, x50,y50,a50, x51,y51,a51, x52,y52,a52, x53,y53,a53, x54,y54,a54, x55,y55,a55, x56,y56,a56, x57,y57,a57, x58,y58,a58, x59,y59,a59, x60,y60,a60, x61,y61,a61 : signed(LEN-1 downto 0) := (others => '0');
	signal x,y,a : signed(LEN-1 downto 0) := (others => '0');

	-- 3.14159265358979323846264338327950288419716939937510582097494459 -- http://oeis.org/A000796
	
	-- constant pi : signed(LEN-1 downto 0) := to_signed(314,LEN);
	-- constant halfpi : signed(LEN-1 downto 0) := to_signed(157,LEN);
	-- constant zero : signed(LEN-1 downto 0) := to_signed(0,LEN);
	constant pi : signed(LEN-1 downto 0) := to_signed(127,LEN);
	constant halfpi : signed(LEN-1 downto 0) := to_signed(63,LEN);
	constant zero : signed(LEN-1 downto 0) := to_signed(0,LEN);
	
begin

-- todo: take in uint8s then tack on carry and sign bits
--
-- If I output the result synchronously then it happens on the next clock cycle.
-- If it's output combinatorially then it happens on the same clock cycle
-- which one is better?

x0 <= abs(x);
y0 <= abs(y);

-- code_generator.go
x1 <= 	x0 +shift_right(y0,0) when y0 > 0 else
		x0 -shift_right(y0,0) when y0 < 0 else 
		x0 when y0 = 0;
		
y1 <= 	-shift_right(x0,0) +y0 when y0 > 0 else
		shift_right(x0,0) +y0 when y0 < 0 else
		y0 when y0 = 0;

a1 <= 	a0 +signed(angles(0)) when y0 > 0 else
		a0 - signed(angles(0)) when y0 < 0 else
		a0 when y0 = 0;

x2 <= 	x1 +shift_right(y1,1) when y1 > 0 else
		x1 -shift_right(y1,1) when y1 < 0 else 
		x1 when y1 = 0;
		
y2 <= 	-shift_right(x1,1) +y1 when y1 > 0 else
		shift_right(x1,1) +y1 when y1 < 0 else
		y1 when y1 = 0;

a2 <= 	a1 +signed(angles(1)) when y1 > 0 else
		a1 - signed(angles(1)) when y1 < 0 else
		a1 when y1 = 0;

x3 <= 	x2 +shift_right(y2,2) when y2 > 0 else
		x2 -shift_right(y2,2) when y2 < 0 else 
		x2 when y2 = 0;
		
y3 <= 	-shift_right(x2,2) +y2 when y2 > 0 else
		shift_right(x2,2) +y2 when y2 < 0 else
		y2 when y2 = 0;

a3 <= 	a2 +signed(angles(2)) when y2 > 0 else
		a2 - signed(angles(2)) when y2 < 0 else
		a2 when y2 = 0;

x4 <= 	x3 +shift_right(y3,3) when y3 > 0 else
		x3 -shift_right(y3,3) when y3 < 0 else 
		x3 when y3 = 0;
		
y4 <= 	-shift_right(x3,3) +y3 when y3 > 0 else
		shift_right(x3,3) +y3 when y3 < 0 else
		y3 when y3 = 0;

a4 <= 	a3 +signed(angles(3)) when y3 > 0 else
		a3 - signed(angles(3)) when y3 < 0 else
		a3 when y3 = 0;

x5 <= 	x4 +shift_right(y4,4) when y4 > 0 else
		x4 -shift_right(y4,4) when y4 < 0 else 
		x4 when y4 = 0;
		
y5 <= 	-shift_right(x4,4) +y4 when y4 > 0 else
		shift_right(x4,4) +y4 when y4 < 0 else
		y4 when y4 = 0;

a5 <= 	a4 +signed(angles(4)) when y4 > 0 else
		a4 - signed(angles(4)) when y4 < 0 else
		a4 when y4 = 0;

x6 <= 	x5 +shift_right(y5,5) when y5 > 0 else
		x5 -shift_right(y5,5) when y5 < 0 else 
		x5 when y5 = 0;
		
y6 <= 	-shift_right(x5,5) +y5 when y5 > 0 else
		shift_right(x5,5) +y5 when y5 < 0 else
		y5 when y5 = 0;

a6 <= 	a5 +signed(angles(5)) when y5 > 0 else
		a5 - signed(angles(5)) when y5 < 0 else
		a5 when y5 = 0;

x7 <= 	x6 +shift_right(y6,6) when y6 > 0 else
		x6 -shift_right(y6,6) when y6 < 0 else 
		x6 when y6 = 0;
		
y7 <= 	-shift_right(x6,6) +y6 when y6 > 0 else
		shift_right(x6,6) +y6 when y6 < 0 else
		y6 when y6 = 0;

a7 <= 	a6 +signed(angles(6)) when y6 > 0 else
		a6 - signed(angles(6)) when y6 < 0 else
		a6 when y6 = 0;

x8 <= 	x7 +shift_right(y7,7) when y7 > 0 else
		x7 -shift_right(y7,7) when y7 < 0 else 
		x7 when y7 = 0;
		
y8 <= 	-shift_right(x7,7) +y7 when y7 > 0 else
		shift_right(x7,7) +y7 when y7 < 0 else
		y7 when y7 = 0;

a8 <= 	a7 +signed(angles(7)) when y7 > 0 else
		a7 - signed(angles(7)) when y7 < 0 else
		a7 when y7 = 0;

x9 <= 	x8 +shift_right(y8,8) when y8 > 0 else
		x8 -shift_right(y8,8) when y8 < 0 else 
		x8 when y8 = 0;
		
y9 <= 	-shift_right(x8,8) +y8 when y8 > 0 else
		shift_right(x8,8) +y8 when y8 < 0 else
		y8 when y8 = 0;

a9 <= 	a8 +signed(angles(8)) when y8 > 0 else
		a8 - signed(angles(8)) when y8 < 0 else
		a8 when y8 = 0;

x10 <= 	x9 +shift_right(y9,9) when y9 > 0 else
		x9 -shift_right(y9,9) when y9 < 0 else 
		x9 when y9 = 0;
		
y10 <= 	-shift_right(x9,9) +y9 when y9 > 0 else
		shift_right(x9,9) +y9 when y9 < 0 else
		y9 when y9 = 0;

a10 <= 	a9 +signed(angles(9)) when y9 > 0 else
		a9 - signed(angles(9)) when y9 < 0 else
		a9 when y9 = 0;

x11 <= 	x10 +shift_right(y10,10) when y10 > 0 else
		x10 -shift_right(y10,10) when y10 < 0 else 
		x10 when y10 = 0;
		
y11 <= 	-shift_right(x10,10) +y10 when y10 > 0 else
		shift_right(x10,10) +y10 when y10 < 0 else
		y10 when y10 = 0;

a11 <= 	a10 +signed(angles(10)) when y10 > 0 else
		a10 - signed(angles(10)) when y10 < 0 else
		a10 when y10 = 0;

x12 <= 	x11 +shift_right(y11,11) when y11 > 0 else
		x11 -shift_right(y11,11) when y11 < 0 else 
		x11 when y11 = 0;
		
y12 <= 	-shift_right(x11,11) +y11 when y11 > 0 else
		shift_right(x11,11) +y11 when y11 < 0 else
		y11 when y11 = 0;

a12 <= 	a11 +signed(angles(11)) when y11 > 0 else
		a11 - signed(angles(11)) when y11 < 0 else
		a11 when y11 = 0;

x13 <= 	x12 +shift_right(y12,12) when y12 > 0 else
		x12 -shift_right(y12,12) when y12 < 0 else 
		x12 when y12 = 0;
		
y13 <= 	-shift_right(x12,12) +y12 when y12 > 0 else
		shift_right(x12,12) +y12 when y12 < 0 else
		y12 when y12 = 0;

a13 <= 	a12 +signed(angles(12)) when y12 > 0 else
		a12 - signed(angles(12)) when y12 < 0 else
		a12 when y12 = 0;

x14 <= 	x13 +shift_right(y13,13) when y13 > 0 else
		x13 -shift_right(y13,13) when y13 < 0 else 
		x13 when y13 = 0;
		
y14 <= 	-shift_right(x13,13) +y13 when y13 > 0 else
		shift_right(x13,13) +y13 when y13 < 0 else
		y13 when y13 = 0;

a14 <= 	a13 +signed(angles(13)) when y13 > 0 else
		a13 - signed(angles(13)) when y13 < 0 else
		a13 when y13 = 0;

x15 <= 	x14 +shift_right(y14,14) when y14 > 0 else
		x14 -shift_right(y14,14) when y14 < 0 else 
		x14 when y14 = 0;
		
y15 <= 	-shift_right(x14,14) +y14 when y14 > 0 else
		shift_right(x14,14) +y14 when y14 < 0 else
		y14 when y14 = 0;

a15 <= 	a14 +signed(angles(14)) when y14 > 0 else
		a14 - signed(angles(14)) when y14 < 0 else
		a14 when y14 = 0;

x16 <= 	x15 +shift_right(y15,15) when y15 > 0 else
		x15 -shift_right(y15,15) when y15 < 0 else 
		x15 when y15 = 0;
		
y16 <= 	-shift_right(x15,15) +y15 when y15 > 0 else
		shift_right(x15,15) +y15 when y15 < 0 else
		y15 when y15 = 0;

a16 <= 	a15 +signed(angles(15)) when y15 > 0 else
		a15 - signed(angles(15)) when y15 < 0 else
		a15 when y15 = 0;

x17 <= 	x16 +shift_right(y16,16) when y16 > 0 else
		x16 -shift_right(y16,16) when y16 < 0 else 
		x16 when y16 = 0;
		
y17 <= 	-shift_right(x16,16) +y16 when y16 > 0 else
		shift_right(x16,16) +y16 when y16 < 0 else
		y16 when y16 = 0;

a17 <= 	a16 +signed(angles(16)) when y16 > 0 else
		a16 - signed(angles(16)) when y16 < 0 else
		a16 when y16 = 0;

x18 <= 	x17 +shift_right(y17,17) when y17 > 0 else
		x17 -shift_right(y17,17) when y17 < 0 else 
		x17 when y17 = 0;
		
y18 <= 	-shift_right(x17,17) +y17 when y17 > 0 else
		shift_right(x17,17) +y17 when y17 < 0 else
		y17 when y17 = 0;

a18 <= 	a17 +signed(angles(17)) when y17 > 0 else
		a17 - signed(angles(17)) when y17 < 0 else
		a17 when y17 = 0;

x19 <= 	x18 +shift_right(y18,18) when y18 > 0 else
		x18 -shift_right(y18,18) when y18 < 0 else 
		x18 when y18 = 0;
		
y19 <= 	-shift_right(x18,18) +y18 when y18 > 0 else
		shift_right(x18,18) +y18 when y18 < 0 else
		y18 when y18 = 0;

a19 <= 	a18 +signed(angles(18)) when y18 > 0 else
		a18 - signed(angles(18)) when y18 < 0 else
		a18 when y18 = 0;

x20 <= 	x19 +shift_right(y19,19) when y19 > 0 else
		x19 -shift_right(y19,19) when y19 < 0 else 
		x19 when y19 = 0;
		
y20 <= 	-shift_right(x19,19) +y19 when y19 > 0 else
		shift_right(x19,19) +y19 when y19 < 0 else
		y19 when y19 = 0;

a20 <= 	a19 +signed(angles(19)) when y19 > 0 else
		a19 - signed(angles(19)) when y19 < 0 else
		a19 when y19 = 0;

x21 <= 	x20 +shift_right(y20,20) when y20 > 0 else
		x20 -shift_right(y20,20) when y20 < 0 else 
		x20 when y20 = 0;
		
y21 <= 	-shift_right(x20,20) +y20 when y20 > 0 else
		shift_right(x20,20) +y20 when y20 < 0 else
		y20 when y20 = 0;

a21 <= 	a20 +signed(angles(20)) when y20 > 0 else
		a20 - signed(angles(20)) when y20 < 0 else
		a20 when y20 = 0;

x22 <= 	x21 +shift_right(y21,21) when y21 > 0 else
		x21 -shift_right(y21,21) when y21 < 0 else 
		x21 when y21 = 0;
		
y22 <= 	-shift_right(x21,21) +y21 when y21 > 0 else
		shift_right(x21,21) +y21 when y21 < 0 else
		y21 when y21 = 0;

a22 <= 	a21 +signed(angles(21)) when y21 > 0 else
		a21 - signed(angles(21)) when y21 < 0 else
		a21 when y21 = 0;

x23 <= 	x22 +shift_right(y22,22) when y22 > 0 else
		x22 -shift_right(y22,22) when y22 < 0 else 
		x22 when y22 = 0;
		
y23 <= 	-shift_right(x22,22) +y22 when y22 > 0 else
		shift_right(x22,22) +y22 when y22 < 0 else
		y22 when y22 = 0;

a23 <= 	a22 +signed(angles(22)) when y22 > 0 else
		a22 - signed(angles(22)) when y22 < 0 else
		a22 when y22 = 0;

x24 <= 	x23 +shift_right(y23,23) when y23 > 0 else
		x23 -shift_right(y23,23) when y23 < 0 else 
		x23 when y23 = 0;
		
y24 <= 	-shift_right(x23,23) +y23 when y23 > 0 else
		shift_right(x23,23) +y23 when y23 < 0 else
		y23 when y23 = 0;

a24 <= 	a23 +signed(angles(23)) when y23 > 0 else
		a23 - signed(angles(23)) when y23 < 0 else
		a23 when y23 = 0;

x25 <= 	x24 +shift_right(y24,24) when y24 > 0 else
		x24 -shift_right(y24,24) when y24 < 0 else 
		x24 when y24 = 0;
		
y25 <= 	-shift_right(x24,24) +y24 when y24 > 0 else
		shift_right(x24,24) +y24 when y24 < 0 else
		y24 when y24 = 0;

a25 <= 	a24 +signed(angles(24)) when y24 > 0 else
		a24 - signed(angles(24)) when y24 < 0 else
		a24 when y24 = 0;

x26 <= 	x25 +shift_right(y25,25) when y25 > 0 else
		x25 -shift_right(y25,25) when y25 < 0 else 
		x25 when y25 = 0;
		
y26 <= 	-shift_right(x25,25) +y25 when y25 > 0 else
		shift_right(x25,25) +y25 when y25 < 0 else
		y25 when y25 = 0;

a26 <= 	a25 +signed(angles(25)) when y25 > 0 else
		a25 - signed(angles(25)) when y25 < 0 else
		a25 when y25 = 0;

x27 <= 	x26 +shift_right(y26,26) when y26 > 0 else
		x26 -shift_right(y26,26) when y26 < 0 else 
		x26 when y26 = 0;
		
y27 <= 	-shift_right(x26,26) +y26 when y26 > 0 else
		shift_right(x26,26) +y26 when y26 < 0 else
		y26 when y26 = 0;

a27 <= 	a26 +signed(angles(26)) when y26 > 0 else
		a26 - signed(angles(26)) when y26 < 0 else
		a26 when y26 = 0;

x28 <= 	x27 +shift_right(y27,27) when y27 > 0 else
		x27 -shift_right(y27,27) when y27 < 0 else 
		x27 when y27 = 0;
		
y28 <= 	-shift_right(x27,27) +y27 when y27 > 0 else
		shift_right(x27,27) +y27 when y27 < 0 else
		y27 when y27 = 0;

a28 <= 	a27 +signed(angles(27)) when y27 > 0 else
		a27 - signed(angles(27)) when y27 < 0 else
		a27 when y27 = 0;

x29 <= 	x28 +shift_right(y28,28) when y28 > 0 else
		x28 -shift_right(y28,28) when y28 < 0 else 
		x28 when y28 = 0;
		
y29 <= 	-shift_right(x28,28) +y28 when y28 > 0 else
		shift_right(x28,28) +y28 when y28 < 0 else
		y28 when y28 = 0;

a29 <= 	a28 +signed(angles(28)) when y28 > 0 else
		a28 - signed(angles(28)) when y28 < 0 else
		a28 when y28 = 0;

x30 <= 	x29 +shift_right(y29,29) when y29 > 0 else
		x29 -shift_right(y29,29) when y29 < 0 else 
		x29 when y29 = 0;
		
y30 <= 	-shift_right(x29,29) +y29 when y29 > 0 else
		shift_right(x29,29) +y29 when y29 < 0 else
		y29 when y29 = 0;

a30 <= 	a29 +signed(angles(29)) when y29 > 0 else
		a29 - signed(angles(29)) when y29 < 0 else
		a29 when y29 = 0;

x31 <= 	x30 +shift_right(y30,30) when y30 > 0 else
		x30 -shift_right(y30,30) when y30 < 0 else 
		x30 when y30 = 0;
		
y31 <= 	-shift_right(x30,30) +y30 when y30 > 0 else
		shift_right(x30,30) +y30 when y30 < 0 else
		y30 when y30 = 0;

a31 <= 	a30 +signed(angles(30)) when y30 > 0 else
		a30 - signed(angles(30)) when y30 < 0 else
		a30 when y30 = 0;

x32 <= 	x31 +shift_right(y31,31) when y31 > 0 else
		x31 -shift_right(y31,31) when y31 < 0 else 
		x31 when y31 = 0;
		
y32 <= 	-shift_right(x31,31) +y31 when y31 > 0 else
		shift_right(x31,31) +y31 when y31 < 0 else
		y31 when y31 = 0;

a32 <= 	a31 +signed(angles(31)) when y31 > 0 else
		a31 - signed(angles(31)) when y31 < 0 else
		a31 when y31 = 0;

x33 <= 	x32 +shift_right(y32,32) when y32 > 0 else
		x32 -shift_right(y32,32) when y32 < 0 else 
		x32 when y32 = 0;
		
y33 <= 	-shift_right(x32,32) +y32 when y32 > 0 else
		shift_right(x32,32) +y32 when y32 < 0 else
		y32 when y32 = 0;

a33 <= 	a32 +signed(angles(32)) when y32 > 0 else
		a32 - signed(angles(32)) when y32 < 0 else
		a32 when y32 = 0;

x34 <= 	x33 +shift_right(y33,33) when y33 > 0 else
		x33 -shift_right(y33,33) when y33 < 0 else 
		x33 when y33 = 0;
		
y34 <= 	-shift_right(x33,33) +y33 when y33 > 0 else
		shift_right(x33,33) +y33 when y33 < 0 else
		y33 when y33 = 0;

a34 <= 	a33 +signed(angles(33)) when y33 > 0 else
		a33 - signed(angles(33)) when y33 < 0 else
		a33 when y33 = 0;

x35 <= 	x34 +shift_right(y34,34) when y34 > 0 else
		x34 -shift_right(y34,34) when y34 < 0 else 
		x34 when y34 = 0;
		
y35 <= 	-shift_right(x34,34) +y34 when y34 > 0 else
		shift_right(x34,34) +y34 when y34 < 0 else
		y34 when y34 = 0;

a35 <= 	a34 +signed(angles(34)) when y34 > 0 else
		a34 - signed(angles(34)) when y34 < 0 else
		a34 when y34 = 0;

x36 <= 	x35 +shift_right(y35,35) when y35 > 0 else
		x35 -shift_right(y35,35) when y35 < 0 else 
		x35 when y35 = 0;
		
y36 <= 	-shift_right(x35,35) +y35 when y35 > 0 else
		shift_right(x35,35) +y35 when y35 < 0 else
		y35 when y35 = 0;

a36 <= 	a35 +signed(angles(35)) when y35 > 0 else
		a35 - signed(angles(35)) when y35 < 0 else
		a35 when y35 = 0;

x37 <= 	x36 +shift_right(y36,36) when y36 > 0 else
		x36 -shift_right(y36,36) when y36 < 0 else 
		x36 when y36 = 0;
		
y37 <= 	-shift_right(x36,36) +y36 when y36 > 0 else
		shift_right(x36,36) +y36 when y36 < 0 else
		y36 when y36 = 0;

a37 <= 	a36 +signed(angles(36)) when y36 > 0 else
		a36 - signed(angles(36)) when y36 < 0 else
		a36 when y36 = 0;

x38 <= 	x37 +shift_right(y37,37) when y37 > 0 else
		x37 -shift_right(y37,37) when y37 < 0 else 
		x37 when y37 = 0;
		
y38 <= 	-shift_right(x37,37) +y37 when y37 > 0 else
		shift_right(x37,37) +y37 when y37 < 0 else
		y37 when y37 = 0;

a38 <= 	a37 +signed(angles(37)) when y37 > 0 else
		a37 - signed(angles(37)) when y37 < 0 else
		a37 when y37 = 0;

x39 <= 	x38 +shift_right(y38,38) when y38 > 0 else
		x38 -shift_right(y38,38) when y38 < 0 else 
		x38 when y38 = 0;
		
y39 <= 	-shift_right(x38,38) +y38 when y38 > 0 else
		shift_right(x38,38) +y38 when y38 < 0 else
		y38 when y38 = 0;

a39 <= 	a38 +signed(angles(38)) when y38 > 0 else
		a38 - signed(angles(38)) when y38 < 0 else
		a38 when y38 = 0;

x40 <= 	x39 +shift_right(y39,39) when y39 > 0 else
		x39 -shift_right(y39,39) when y39 < 0 else 
		x39 when y39 = 0;
		
y40 <= 	-shift_right(x39,39) +y39 when y39 > 0 else
		shift_right(x39,39) +y39 when y39 < 0 else
		y39 when y39 = 0;

a40 <= 	a39 +signed(angles(39)) when y39 > 0 else
		a39 - signed(angles(39)) when y39 < 0 else
		a39 when y39 = 0;

x41 <= 	x40 +shift_right(y40,40) when y40 > 0 else
		x40 -shift_right(y40,40) when y40 < 0 else 
		x40 when y40 = 0;
		
y41 <= 	-shift_right(x40,40) +y40 when y40 > 0 else
		shift_right(x40,40) +y40 when y40 < 0 else
		y40 when y40 = 0;

a41 <= 	a40 +signed(angles(40)) when y40 > 0 else
		a40 - signed(angles(40)) when y40 < 0 else
		a40 when y40 = 0;

x42 <= 	x41 +shift_right(y41,41) when y41 > 0 else
		x41 -shift_right(y41,41) when y41 < 0 else 
		x41 when y41 = 0;
		
y42 <= 	-shift_right(x41,41) +y41 when y41 > 0 else
		shift_right(x41,41) +y41 when y41 < 0 else
		y41 when y41 = 0;

a42 <= 	a41 +signed(angles(41)) when y41 > 0 else
		a41 - signed(angles(41)) when y41 < 0 else
		a41 when y41 = 0;

x43 <= 	x42 +shift_right(y42,42) when y42 > 0 else
		x42 -shift_right(y42,42) when y42 < 0 else 
		x42 when y42 = 0;
		
y43 <= 	-shift_right(x42,42) +y42 when y42 > 0 else
		shift_right(x42,42) +y42 when y42 < 0 else
		y42 when y42 = 0;

a43 <= 	a42 +signed(angles(42)) when y42 > 0 else
		a42 - signed(angles(42)) when y42 < 0 else
		a42 when y42 = 0;

x44 <= 	x43 +shift_right(y43,43) when y43 > 0 else
		x43 -shift_right(y43,43) when y43 < 0 else 
		x43 when y43 = 0;
		
y44 <= 	-shift_right(x43,43) +y43 when y43 > 0 else
		shift_right(x43,43) +y43 when y43 < 0 else
		y43 when y43 = 0;

a44 <= 	a43 +signed(angles(43)) when y43 > 0 else
		a43 - signed(angles(43)) when y43 < 0 else
		a43 when y43 = 0;

x45 <= 	x44 +shift_right(y44,44) when y44 > 0 else
		x44 -shift_right(y44,44) when y44 < 0 else 
		x44 when y44 = 0;
		
y45 <= 	-shift_right(x44,44) +y44 when y44 > 0 else
		shift_right(x44,44) +y44 when y44 < 0 else
		y44 when y44 = 0;

a45 <= 	a44 +signed(angles(44)) when y44 > 0 else
		a44 - signed(angles(44)) when y44 < 0 else
		a44 when y44 = 0;

x46 <= 	x45 +shift_right(y45,45) when y45 > 0 else
		x45 -shift_right(y45,45) when y45 < 0 else 
		x45 when y45 = 0;
		
y46 <= 	-shift_right(x45,45) +y45 when y45 > 0 else
		shift_right(x45,45) +y45 when y45 < 0 else
		y45 when y45 = 0;

a46 <= 	a45 +signed(angles(45)) when y45 > 0 else
		a45 - signed(angles(45)) when y45 < 0 else
		a45 when y45 = 0;

x47 <= 	x46 +shift_right(y46,46) when y46 > 0 else
		x46 -shift_right(y46,46) when y46 < 0 else 
		x46 when y46 = 0;
		
y47 <= 	-shift_right(x46,46) +y46 when y46 > 0 else
		shift_right(x46,46) +y46 when y46 < 0 else
		y46 when y46 = 0;

a47 <= 	a46 +signed(angles(46)) when y46 > 0 else
		a46 - signed(angles(46)) when y46 < 0 else
		a46 when y46 = 0;

x48 <= 	x47 +shift_right(y47,47) when y47 > 0 else
		x47 -shift_right(y47,47) when y47 < 0 else 
		x47 when y47 = 0;
		
y48 <= 	-shift_right(x47,47) +y47 when y47 > 0 else
		shift_right(x47,47) +y47 when y47 < 0 else
		y47 when y47 = 0;

a48 <= 	a47 +signed(angles(47)) when y47 > 0 else
		a47 - signed(angles(47)) when y47 < 0 else
		a47 when y47 = 0;

x49 <= 	x48 +shift_right(y48,48) when y48 > 0 else
		x48 -shift_right(y48,48) when y48 < 0 else 
		x48 when y48 = 0;
		
y49 <= 	-shift_right(x48,48) +y48 when y48 > 0 else
		shift_right(x48,48) +y48 when y48 < 0 else
		y48 when y48 = 0;

a49 <= 	a48 +signed(angles(48)) when y48 > 0 else
		a48 - signed(angles(48)) when y48 < 0 else
		a48 when y48 = 0;

x50 <= 	x49 +shift_right(y49,49) when y49 > 0 else
		x49 -shift_right(y49,49) when y49 < 0 else 
		x49 when y49 = 0;
		
y50 <= 	-shift_right(x49,49) +y49 when y49 > 0 else
		shift_right(x49,49) +y49 when y49 < 0 else
		y49 when y49 = 0;

a50 <= 	a49 +signed(angles(49)) when y49 > 0 else
		a49 - signed(angles(49)) when y49 < 0 else
		a49 when y49 = 0;

x51 <= 	x50 +shift_right(y50,50) when y50 > 0 else
		x50 -shift_right(y50,50) when y50 < 0 else 
		x50 when y50 = 0;
		
y51 <= 	-shift_right(x50,50) +y50 when y50 > 0 else
		shift_right(x50,50) +y50 when y50 < 0 else
		y50 when y50 = 0;

a51 <= 	a50 +signed(angles(50)) when y50 > 0 else
		a50 - signed(angles(50)) when y50 < 0 else
		a50 when y50 = 0;

x52 <= 	x51 +shift_right(y51,51) when y51 > 0 else
		x51 -shift_right(y51,51) when y51 < 0 else 
		x51 when y51 = 0;
		
y52 <= 	-shift_right(x51,51) +y51 when y51 > 0 else
		shift_right(x51,51) +y51 when y51 < 0 else
		y51 when y51 = 0;

a52 <= 	a51 +signed(angles(51)) when y51 > 0 else
		a51 - signed(angles(51)) when y51 < 0 else
		a51 when y51 = 0;

x53 <= 	x52 +shift_right(y52,52) when y52 > 0 else
		x52 -shift_right(y52,52) when y52 < 0 else 
		x52 when y52 = 0;
		
y53 <= 	-shift_right(x52,52) +y52 when y52 > 0 else
		shift_right(x52,52) +y52 when y52 < 0 else
		y52 when y52 = 0;

a53 <= 	a52 +signed(angles(52)) when y52 > 0 else
		a52 - signed(angles(52)) when y52 < 0 else
		a52 when y52 = 0;

x54 <= 	x53 +shift_right(y53,53) when y53 > 0 else
		x53 -shift_right(y53,53) when y53 < 0 else 
		x53 when y53 = 0;
		
y54 <= 	-shift_right(x53,53) +y53 when y53 > 0 else
		shift_right(x53,53) +y53 when y53 < 0 else
		y53 when y53 = 0;

a54 <= 	a53 +signed(angles(53)) when y53 > 0 else
		a53 - signed(angles(53)) when y53 < 0 else
		a53 when y53 = 0;

x55 <= 	x54 +shift_right(y54,54) when y54 > 0 else
		x54 -shift_right(y54,54) when y54 < 0 else 
		x54 when y54 = 0;
		
y55 <= 	-shift_right(x54,54) +y54 when y54 > 0 else
		shift_right(x54,54) +y54 when y54 < 0 else
		y54 when y54 = 0;

a55 <= 	a54 +signed(angles(54)) when y54 > 0 else
		a54 - signed(angles(54)) when y54 < 0 else
		a54 when y54 = 0;

x56 <= 	x55 +shift_right(y55,55) when y55 > 0 else
		x55 -shift_right(y55,55) when y55 < 0 else 
		x55 when y55 = 0;
		
y56 <= 	-shift_right(x55,55) +y55 when y55 > 0 else
		shift_right(x55,55) +y55 when y55 < 0 else
		y55 when y55 = 0;

a56 <= 	a55 +signed(angles(55)) when y55 > 0 else
		a55 - signed(angles(55)) when y55 < 0 else
		a55 when y55 = 0;

x57 <= 	x56 +shift_right(y56,56) when y56 > 0 else
		x56 -shift_right(y56,56) when y56 < 0 else 
		x56 when y56 = 0;
		
y57 <= 	-shift_right(x56,56) +y56 when y56 > 0 else
		shift_right(x56,56) +y56 when y56 < 0 else
		y56 when y56 = 0;

a57 <= 	a56 +signed(angles(56)) when y56 > 0 else
		a56 - signed(angles(56)) when y56 < 0 else
		a56 when y56 = 0;

x58 <= 	x57 +shift_right(y57,57) when y57 > 0 else
		x57 -shift_right(y57,57) when y57 < 0 else 
		x57 when y57 = 0;
		
y58 <= 	-shift_right(x57,57) +y57 when y57 > 0 else
		shift_right(x57,57) +y57 when y57 < 0 else
		y57 when y57 = 0;

a58 <= 	a57 +signed(angles(57)) when y57 > 0 else
		a57 - signed(angles(57)) when y57 < 0 else
		a57 when y57 = 0;

x59 <= 	x58 +shift_right(y58,58) when y58 > 0 else
		x58 -shift_right(y58,58) when y58 < 0 else 
		x58 when y58 = 0;
		
y59 <= 	-shift_right(x58,58) +y58 when y58 > 0 else
		shift_right(x58,58) +y58 when y58 < 0 else
		y58 when y58 = 0;

a59 <= 	a58 +signed(angles(58)) when y58 > 0 else
		a58 - signed(angles(58)) when y58 < 0 else
		a58 when y58 = 0;

x60 <= 	x59 +shift_right(y59,59) when y59 > 0 else
		x59 -shift_right(y59,59) when y59 < 0 else 
		x59 when y59 = 0;
		
y60 <= 	-shift_right(x59,59) +y59 when y59 > 0 else
		shift_right(x59,59) +y59 when y59 < 0 else
		y59 when y59 = 0;

a60 <= 	a59 +signed(angles(59)) when y59 > 0 else
		a59 - signed(angles(59)) when y59 < 0 else
		a59 when y59 = 0;

x61 <= 	x60 +shift_right(y60,60) when y60 > 0 else
		x60 -shift_right(y60,60) when y60 < 0 else 
		x60 when y60 = 0;
		
y61 <= 	-shift_right(x60,60) +y60 when y60 > 0 else
		shift_right(x60,60) +y60 when y60 < 0 else
		y60 when y60 = 0;

a61 <= 	a60 +signed(angles(60)) when y60 > 0 else
		a60 - signed(angles(60)) when y60 < 0 else
		a60 when y60 = 0;
		

a <= 	a61 	when x>0 and y>0 else
		pi-a61	when x<0 and y>0 else
		-pi+a1	when x<0 and y<0 else
		-a61	when x>0 and y<0 else
		zero	when x>0 and y=0 else
		halfpi	when x=0 and y>0 else
		pi		when x<0 and y=0 else
		-halfpi	when x=0 and y<0 else
		a61		when x=0 and y=0;	-- ???

aout <= resize(a,aout'length);
		
   process (clk)
   begin
		if rising_edge(clk) then
			x <= resize(xin,x0'length);
			y <= resize(yin,y0'length);
			outstrobe <= instrobe;
		end if;
  end process;
  
end architecture behavioral;
