
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg_A IS
	PORT(
		DATA : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		GATE : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END reg_A;

ARCHITECTURE SYN OF reg_A IS
BEGIN
	PROCESS(GATE)
	BEGIN
		IF GATE = '1' THEN
			Q <= DATA;
		END IF;
	END PROCESS;

END SYN;

