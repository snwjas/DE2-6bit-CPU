
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DR IS
	PORT(
		DATA : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		GATE : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END DR;

ARCHITECTURE SYN OF DR IS
BEGIN
	PROCESS(GATE)
	BEGIN
		IF GATE = '1' THEN
			Q <= DATA;
		END IF;
	END PROCESS;

END SYN;

