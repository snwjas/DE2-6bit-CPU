-- 6-bit ALU
-- 0000	 add	Y = A add B
-- 0001	 sub	Y = A sub B
-- 0010	 and	Y = A and B
-- 0011	 or	  	Y = A or B
-- 0100	 not 	Y = not A
-- 0101	 nand  	Y = A nand B
-- 0110	 nor 	Y = A nor B
-- 0111	 xor	Y = A xor B

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALU IS
	PORT (CLK : IN STD_LOGIC;
		  S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  A : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		  B : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		  Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  V : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ALU;

ARCHITECTURE Structure OF ALU IS
	-- Arithmetic input A and B
	SIGNAL AAin : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL BAin : STD_LOGIC_VECTOR(5 DOWNTO 0);
	-- Logical input A and B
	SIGNAL ALin : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL BLin : STD_LOGIC_VECTOR(5 DOWNTO 0);
	-- Output Y
	SIGNAL Yout : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN
	AAin <= A WHEN A(5) = '0' ELSE
			(A(5 DOWNTO 4) & (NOT(A(3 DOWNTO 0)) + 1));
	BAin <= B WHEN B(5) = '0' ELSE
			(B(5 DOWNTO 4) & (NOT(B(3 DOWNTO 0)) + 1));
	ALin <= "00" & A(3 DOWNTO 0);
	BLin <= "00" & B(3 DOWNTO 0);

	PROCESS(CLK, S, A, B)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF S = "0000" THEN
				Yout <= AAin + BAin;
			ELSIF S = "0001" THEN
				Yout <= AAin - BAin;
			ELSIF S = "0010" THEN
				Yout <= ALin AND BLin;
			ELSIF S = "0011" THEN
				Yout <= ALin OR BLin;
			ELSIF S = "0100" THEN
				Yout <= NOT ALin;
			ELSIF S = "0101" THEN
				Yout <= ALin NAND BLin;
			ELSIF S = "0110" THEN
				Yout <= ALin NOR BLin;
			ELSIF S = "0111" THEN
				Yout <= ALin XOR BLin;
			END IF;
		END IF;
	END PROCESS;

	Y <= Yout(3 DOWNTO 0) WHEN Yout(5) = '0' ELSE
		 (NOT(Yout(3 DOWNTO 0)) + 1);
	V <= Yout(5 DOWNTO 4);

END Structure;