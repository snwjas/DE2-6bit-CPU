-- 4-beat pulse generator

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY timing IS
    PORT (CLK : IN STD_LOGIC;
    	  GEN : IN STD_LOGIC;
		  CLKOUT : OUT STD_LOGIC_VECTOR(0 TO 3)
	);
END timing;

ARCHITECTURE behavioral OF timing IS
	SIGNAL countsec : INTEGER RANGE 0 TO 4 := 4;

BEGIN
	PROCESS(CLK, GEN)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF GEN = '0' AND GEN'LAST_VALUE = '1' THEN
				countsec <= 0;
			END IF;

			IF countsec < 4 THEN
				countsec <= countsec + 1;
			END IF;
		END IF;
	END PROCESS;

	CLKOUT(0) <= '1' WHEN countsec = 0 ELSE '0';
	CLKOUT(1) <= '1' WHEN countsec = 1 ELSE '0';
	CLKOUT(2) <= '1' WHEN countsec = 2 ELSE '0';
	CLKOUT(3) <= '1' WHEN countsec = 3 ELSE '0';

END behavioral;
