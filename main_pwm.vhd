----------------------------------------------------------------------------------
-- Company: Tecnol�gico de Monterrey
-- Engineer: Mat�as V�zquez Pi��n
-- 
-- Create Date: 10/23/2020 11:48:38 PM
-- Design Name: PWM sigmal generator
-- Module Name: main_pwm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_pwm is  
port (
    clk100m : in std_logic;
    btn_in  : in std_logic;
    duty_cycle: in integer;
    pwm_out : out std_logic
);
end main_pwm;

architecture Behavioral of main_pwm is

subtype u20 is unsigned(19 downto 0);
signal counter      : u20 := x"00000";

constant clk_freq   : integer := 50_000_000;        -- Clock frequency in Hz (20 ns)
constant pwm_freq   : integer := 50;                -- PWM sigmal frequency in Hz (20 ms)
constant period     : integer := clk_freq/pwm_freq; -- N�mero de pulsos de reloj en un ciclo PWM
                                                    -- N�mero de pulsos de reloj para ciclo de trabajo
                                                    --  25,000 -> -90�, 50,000 -> -45�, 75,000 -> 0�
                                                    -- 100,000 ->  45�, 125,000 -> 90�

signal pwm_counter  : std_logic := '0';
signal stateHigh    : std_logic := '1';

signal clk50m       : std_logic;
signal reset        : std_logic;
signal locked       : std_logic;

component clk_wiz_0 port (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

begin

clock_instance : clk_wiz_0 port map ( 
  -- Clock out ports  
   clk_out1 => clk50m,
  -- Status and control signals                
   reset => reset,
   locked => locked,
   -- Clock in ports
   clk_in1 => clk100m );
 
pwm_generator : process(clk50m) is
variable cur : u20 := counter;
begin
    if (rising_edge(clk50m) and btn_in = '1') then
        cur := cur + 1;  
        counter <= cur;
        if (cur <= duty_cycle) then
            pwm_counter <= '1'; 
        elsif (cur > duty_cycle) then
            pwm_counter <= '0';
        elsif (cur = period) then
            cur := x"00000";
        end if;  
    end if;
end process pwm_generator;

pwm_out <= pwm_counter;

end Behavioral;
