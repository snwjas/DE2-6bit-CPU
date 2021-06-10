-- A 6-bit CPU, included two sign bits.
--
-- Input :
-- CLK : Internal clock
-- KEY[0] : Four beat pulse generation
-- SW[17]-SW[14] : Operation code(instruction)
-- SW[13]-SW[12] : Operand A, Register address
-- SW[11]-SW[6] : Operand B, number if SW[11] = 0 else Register address(SW[10]-SW[9])
-- SW[0] : Single step or continuous
--
-- Output :
-- LEDR : The switch red light
-- LEDG[3]-LEDG[0] : IF ID EX WB
-- LEDG[7]-LEDG[4] : Number of instructions
-- HEX7, HEX6 : Show the operand A
-- HEX5, HEX4 : Show the operand A
-- HEX3, HEX2, HEX1 : Show the operation result, HEX3 is the overflow
-- HEX0 : Close it 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CPU_6bit IS
    PORT (CLOCK_27 : IN STD_LOGIC;
    	  KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    	  SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		  LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		  LEDG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END CPU_6bit;

ARCHITECTURE cpu OF CPU_6bit IS
	COMPONENT timing
	    PORT (CLK : IN STD_LOGIC;
	    	  GEN : IN STD_LOGIC;
	    	  STP_CON : IN STD_LOGIC;
			  CLKOUT : OUT STD_LOGIC_VECTOR(0 TO 3)
		);
	END COMPONENT;

	COMPONENT PC
		PORT(
			CLK : IN STD_LOGIC;
			CLKEN : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			ADDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT IIC
		PORT(
			CLK : IN STD_LOGIC;
			INC_DEC : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			ADDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT comparator
		PORT(
			A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Q : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT PM
		PORT (
			DATA: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
			WCLK: IN STD_LOGIC;
			WADR: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			RCLK: IN STD_LOGIC;
			RADR: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Q: OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ALU
		PORT (CLK : IN STD_LOGIC;
			  S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  A : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			  B : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			  Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			  V : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT IR
		PORT(
			DATA : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
			CLK : IN STD_LOGIC;
			WREN : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT GR0_3
		PORT(
			OP : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
			CLK : IN STD_LOGIC;
			WBDATA : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			WBEN : IN STD_LOGIC;
			QA : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			QB : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT DR
		PORT(
			DATA : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CLK : IN STD_LOGIC;
			WREN : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT PSW
		PORT(
			DATA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			CLK : IN STD_LOGIC;
			WREN : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT bcd7seg
		PORT (BCD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  HEXH : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			  HEXL : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ov7seg
		PORT (OV : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			  HEX : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;


	SIGNAL clk : STD_LOGIC_VECTOR(0 TO 3);
	SIGNAL wradr : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL rdadr : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL comp : STD_LOGIC;
	SIGNAL i_pm : STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL i_ir : STD_LOGIC_VECTOR(11 DOWNTO 0);

	SIGNAL a : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL b : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL y : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL yy : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL v : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL vv : STD_LOGIC_VECTOR(1 DOWNTO 0);

	BEGIN
	LEDR <= SW;
	HEX0 <= "1111111";
	LEDG(7 DOWNTO 4) <= wradr;
	LEDG(0) <= comp;

	TimingGenerator: timing PORT MAP (CLOCK_27, KEY(0), SW(0), clk);
-- IF
	InstructionInputController: IIC PORT MAP (KEY(1), SW(1), NOT(KEY(2)), wradr);
	ProgramCounter: PC PORT MAP (clk(0), NOT(comp), NOT(KEY(2)), rdadr);
	Compare: comparator PORT MAP (wradr, rdadr, comp);
	ProgramMemory: PM PORT MAP (SW(17 DOWNTO 6), KEY(1), wradr, clk(0), rdadr, i_pm);
	InstructionRegister: IR PORT MAP (i_pm, clk(0), clk(0), i_ir);
-- ID
	GeneralRegister0_3: GR0_3 PORT MAP (i_ir, clk(3), (vv(1)& vv(1)& yy), clk(2), a, b);
-- EX
	Operation: ALU PORT MAP (clk(2), i_ir(11 DOWNTO 8), a, b, y, v);
-- WB
	DataRegister: DR PORT MAP (y, clk(3), clk(3), yy);
	ProgramStatusWord: PSW PORT MAP (v, clk(3), clk(3), vv);
-- char7seg show
	char7seg_A: bcd7seg PORT MAP (a(3 DOWNTO 0), HEX7, HEX6);
	char7seg_B: bcd7seg PORT MAP (b(3 DOWNTO 0), HEX5, HEX4);
	char7seg_V: ov7seg PORT MAP (vv, HEX3);
	char7seg_Y: bcd7seg PORT MAP (yy, HEX2, HEX1);

END cpu;
