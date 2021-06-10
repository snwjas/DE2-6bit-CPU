-- 8-bit ALU
-- 000	add	  Y = A add B
-- 001	sub	  Y = A sub B
-- 010	and	  Y = A and B
-- 011	or	  Y = A or B
-- 100	NOT	  Y = not A
-- 101	nand  Y = A nand B
-- 110	nor	  Y = A nor B
-- 111	xor	  Y = A xor B

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALU IS
	PORT (CLK : IN STD_LOGIC;
		  S : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
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
			CASE S IS
				WHEN "000" =>
					Yout <= AAin + BAin;
				WHEN "001" =>
					Yout <= AAin - BAin;
				WHEN "010" =>
					Yout <= ALin AND BLin;
				WHEN "011" =>
					Yout <= ALin OR BLin;
				WHEN "100" =>
					Yout <= NOT ALin;
				WHEN "101" =>
					Yout <= ALin NAND BLin;
				WHEN "110" =>
					Yout <= ALin NOR BLin;
				WHEN OTHERS =>
					Yout <= ALin XOR BLin;
			END CASE;
		END IF;
	END PROCESS;

	Y <= Yout(3 DOWNTO 0) WHEN Yout(5) = '0' ELSE
		 (NOT(Yout(3 DOWNTO 0)) + 1);
	V <= Yout(5 DOWNTO 4);
END Structure;