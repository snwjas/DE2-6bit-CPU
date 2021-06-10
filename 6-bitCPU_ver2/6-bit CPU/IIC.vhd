-- Instruction Input Controller
--
-- Input:
-- CCLK: 
-- INCI: Add an instruction later
-- DECI: Remove the previous instruction
-- RST: Reset instruction number to zero
-- 
-- Output:
-- ADDR: Instruction Write Address(Number of instructions)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY IIC IS
	PORT(
		CLK : IN STD_LOGIC;
		INC_DEC : IN STD_LOGIC;
		RST : IN STD_LOGIC := '0';
		ADDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END IIC;


ARCHITECTURE SYN OF IIC IS
	SIGNAL count : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
BEGIN
	PROCESS(CLK, INC_DEC, RST)
	BEGIN
		IF RST = '1' THEN
			count <= "0000";
		ELSIF CLK'EVENT AND CLK = '1' THEN
			IF INC_DEC = '0' THEN
				IF count < "1111" THEN
					count <= count + 1;
				END IF;
			ELSE
				IF count > "0000" THEN
					count <= count - 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	ADDR <= count;

END SYN;
