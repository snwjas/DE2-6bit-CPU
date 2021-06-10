-- 4-beat pulse generator

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY timing IS
    PORT (CLK : IN STD_LOGIC;
    	  GEN : IN STD_LOGIC;
    	  STP_CON : IN STD_LOGIC;
		  CLKOUT : OUT STD_LOGIC_VECTOR(0 TO 3)
	);
END timing;

ARCHITECTURE behavioral OF timing IS
	SIGNAL countsec : INTEGER RANGE 0 TO 4 := 4;
	SIGNAL countemp : INTEGER RANGE 0 TO 64 := 0;

BEGIN
	count:PROCESS(CLK, GEN, STP_CON)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF STP_CON = '0' THEN
				IF GEN = '0' AND GEN'LAST_VALUE = '1' THEN
					countsec <= 0;
				END IF;

				IF countsec < 4 THEN
					countsec <= countsec + 1;
				END IF;
			ELSE
				IF GEN = '0' AND GEN'LAST_VALUE = '1' THEN
					countemp <= 0;
				END IF;
					IF countemp < 64 THEN
						IF countsec < 3 THEN
							countsec <= countsec + 1;
						ELSE
							countsec <= 0;
						END IF;
						countemp <= countemp + 1;
					ELSE
						countsec <= 4;
					END IF;
			END IF;
		END IF;
	END PROCESS;

	CLKOUT(0) <= '1' WHEN countsec = 0 ELSE '0';
	CLKOUT(1) <= '1' WHEN countsec = 1 ELSE '0';
	CLKOUT(2) <= '1' WHEN countsec = 2 ELSE '0';
	CLKOUT(3) <= '1' WHEN countsec = 3 ELSE '0';
END behavioral;
