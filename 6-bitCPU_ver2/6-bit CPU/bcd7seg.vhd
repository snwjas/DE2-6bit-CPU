-- 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd7seg IS
	PORT (BCD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  HEXH : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  HEXL : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END bcd7seg;

ARCHITECTURE behavioral OF bcd7seg IS
	SIGNAL bcdcheck : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL dish : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL disl : STD_LOGIC_VECTOR(6 DOWNTO 0);

	BEGIN
		check : PROCESS(BCD)
		BEGIN
			IF (BCD(3) AND (BCD(2) OR BCD(1))) = '0' THEN
				dish <= "1000000";
				bcdcheck <= BCD;
			ELSE
				dish <= "1111001";
				bcdcheck <= NOT(BCD(3))& (BCD(2) AND BCD(1))& NOT(BCD(1))& BCD(0); 
			END IF;
		END PROCESS;

		seg : PROCESS(bcdcheck)
		BEGIN
			CASE bcdcheck IS
				WHEN "0000" => disl <= "1000000"; -- 0
				WHEN "0001" => disl <= "1111001"; -- 1
				WHEN "0010" => disl <= "0100100"; -- 2
				WHEN "0011" => disl <= "0110000"; -- 3
				WHEN "0100" => disl <= "0011001"; -- 4
				WHEN "0101" => disl <= "0010010"; -- 5
				WHEN "0110" => disl <= "0000010"; -- 6
				WHEN "0111" => disl <= "1111000"; -- 7
				WHEN "1000" => disl <= "0000000"; -- 8
				WHEN OTHERS => disl <= "0010000"; -- 9
			END CASE;
		END PROCESS;

		HEXH <= dish;
		HEXL <= disl;
END behavioral; 