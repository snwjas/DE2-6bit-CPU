-- 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY DR IS
	PORT(
		DATA : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		CLK : IN STD_LOGIC;
		WREN : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END DR;

ARCHITECTURE SYN OF DR IS
	SIGNAL d : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	PROCESS(CLK, WREN)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF WREN = '1' THEN
				d <= DATA;
			END IF;
		END IF;
	END PROCESS;

	Q <= d;

END SYN;
