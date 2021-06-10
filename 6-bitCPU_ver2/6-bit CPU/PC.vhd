-- Program Counter

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PC IS
	PORT(
		CLK : IN STD_LOGIC;
		CLKEN : IN STD_LOGIC;
		RST : IN STD_LOGIC := '0';
		ADDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END PC;

ARCHITECTURE SYN OF PC IS
	SIGNAL count : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
BEGIN
	PROCESS(CLK, CLKEN, RST)
	BEGIN
		IF RST = '1' THEN
			count <= "0000";
		ELSIF CLK'EVENT AND CLK = '1' AND CLKEN = '1' THEN
			IF count < "1111" THEN
				count <= count + 1;
			END IF;
		END IF;
	END PROCESS;

	ADDR <= count;

END SYN;

