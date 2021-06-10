-- 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ov7seg IS
	PORT (
		OV : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	  	HEX : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END ov7seg;

ARCHITECTURE behavioral OF ov7seg IS
BEGIN
	seg : PROCESS(OV)
	BEGIN
		CASE OV IS
			WHEN "00" => HEX <= "1111111"; -- Positive number
			WHEN "01" => HEX <= "1000001"; -- Positive spillover
			WHEN "10" => HEX <= "1001000"; -- Negative Overflow
			WHEN OTHERS => HEX <= "0111111"; -- Negative
		END CASE;
	END PROCESS;
END behavioral;