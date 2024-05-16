library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SmartCar is
    Port (
        clk           : in STD_LOGIC;
        black_tape    : in STD_LOGIC;
        start_sw      : in STD_LOGIC;
		  obstacle      : in STD_LOGIC;
        AN            : out STD_LOGIC_VECTOR (3 downto 0);
        SEG           : out STD_LOGIC_VECTOR (6 downto 0);
        motor_out  	 : out STD_LOGIC_vector(3 downto 0)
    );	 
end SmartCar;



architecture car of SmartCar is
    component SevenSegmentDisplay
        Port (
            clk 			: in STD_LOGIC;
				black_tape  : in STD_LOGIC;
            AN  			: out STD_LOGIC_VECTOR (3 downto 0);
            SEG 			: out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    component MotorControl
        Port (
            clk        : in  STD_LOGIC;
            start_sw   : in  STD_LOGIC;
				obstacle   : in  STD_LOGIC;
            motor_out  : out STD_LOGIC_vector(3 downto 0)
        );
    end component;

    signal AN_local      : STD_LOGIC_VECTOR (3 downto 0);
    signal SEG_local     : STD_LOGIC_VECTOR (6 downto 0);
    signal motor_out_local : STD_LOGIC_vector(3 downto 0);

begin
    display_controller: SevenSegmentDisplay
        port map (
            clk        => clk,
				black_tape => black_tape,
            AN         => AN_local,
            SEG        => SEG_local
        );

    motor_controller: MotorControl
        port map (
            clk        => clk,
            start_sw   => start_sw,
				obstacle   => obstacle,
            motor_out  => motor_out_local
        );

    AN <= AN_local;
    SEG <= SEG_local;
    motor_out <= motor_out_local;  
end car;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SevenSegmentDisplay is
    Port (
        clk 		  : in STD_LOGIC;
		  black_tape  : in STD_LOGIC;
        AN  		  : out STD_LOGIC_VECTOR (3 downto 0);
        SEG 		  : out STD_LOGIC_VECTOR (6 downto 0)
    );
end SevenSegmentDisplay;

architecture Behavioral of SevenSegmentDisplay is
    signal timer : integer := 0;
    signal count : integer := 0;
    signal digit_index : integer range 0 to 3 := 0;
	 signal display_on  : boolean := FALSE;
	 signal sensor_prev    : STD_LOGIC := '0';

    type seg_pattern is array (0 to 3) of STD_LOGIC_VECTOR (6 downto 0);
    constant patterns : seg_pattern := (
        "1001000", -- 'H'
        "0110000", -- 'E'
        "1110001", -- 'L'
        "0011000"  -- 'P'
    );
	 
    type anode_pattern is array (0 to 3) of STD_LOGIC_VECTOR (3 downto 0);
    constant anodes : anode_pattern := (
        "1110", -- First digit
        "1101", -- Second digit
        "1011", -- Third digit
        "0111"  -- Fourth digit
    );

begin
    process(black_tape)
    begin
        if rising_edge(clk) then
				if black_tape = '0' then
					timer <= 0;
					display_on <= TRUE;
				end if;
				if display_on then
					count <= count + 1;
					
					if count = 50000 then
						count <= 0;
						digit_index <= (digit_index + 1) mod 4;
					end if;
					
					AN <= anodes(digit_index);
					SEG <= patterns(digit_index);
					
					if black_tape = '1' then
						timer <= timer + 1;
					end if;
					
					if timer = 100000000 then
						display_on <= FALSE;
					end if;
					
				else
					AN <= "1111";
					SEG <= "1111111";
				end if;
				
        end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MotorControl is
    Port (
        clk        : in  STD_LOGIC;
	     start_sw   : in  STD_LOGIC;
        obstacle   : in  STD_LOGIC;
        motor_out  : out STD_LOGIC_vector(3 downto 0)
    );
end MotorControl;

architecture Behavioral of MotorControl is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if start_sw = '0' and obstacle = '1' then
                motor_out <= "1010";
            else
                motor_out <= "1010";
            end if;
        end if;
    end process;
end Behavioral;