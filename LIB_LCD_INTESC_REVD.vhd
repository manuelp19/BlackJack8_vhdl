----------------------------------------------------------------------------------
-- COPYRIGHT 2019 Jesús Eduardo Méndez Rosales
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
--
--							LIBRERÍA LCD
--
-- Descripción: Con ésta librería podrás implementar códigos para una LCD 16x2 de manera
-- fácil y rápida, con todas las ventajas de utilizar una FPGA.
--
-- Características:
-- 
--	Los comandos que puedes utilizar son los siguientes:
--
-- LCD_INI() -> Inicializa la lcd.
--		 			 NOTA: Dentro de los paréntesis poner un vector de 2 bits para encender o apagar
--					 		 el cursor y activar o desactivar el parpadeo.
--
--		"1x" -- Cursor ON
--		"0x" -- Cursor OFF
--		"x1" -- Parpadeo ON
--		"x0" -- Parpadeo OFF
--
--   Por ejemplo: LCD_INI("10") -- Inicializar LCD con cursor encendido y sin parpadeo 
--	
--			
-- CHAR() -> Manda una letra mayúscula o minúscula
--
--				 IMPORTANTE: 1) Debido a que VHDL no es sensible a mayúsculas y minúsculas, si se quiere
--								    escribir una letra mayúscula se debe escribir una "M" antes de la letra.
--								 2) Si se quiere escribir la letra "S" mayúscula, se declara "MAS"
--											
-- 	Por ejemplo: CHAR(A)  -- Escribe en la LCD la letra "a"
--						 CHAR(MA) -- Escribe en la LCD la letra "A"	
--						 CHAR(S)	 -- Escribe en la LCD la letra "s"
--						 CHAR(MAS)	 -- Escribe en la LCD la letra "S"	
--	
--
-- POS() -> Escribir en la posición que se indique.
--				NOTA: Dentro de los paréntesis se dene poner la posición de la LCD a la que se quiere ir, empezando
--						por el renglón seguido de la posición vertical, ambos números separados por una coma.
--		
--		Por ejemplo: POS(1,2) -- Manda cursor al renglón 1, poscición 2
--						 POS(2,4) -- Manda cursor al renglón 2, poscición 4		
--
--
-- CHAR_ASCII() -> Escribe un caracter a partir de su código en ASCII
--						 NOTA: Dentro de los parentesis escribir x"(número hex.)"
--
--		Por ejemplo: CHAR_ASCII(x"40") -- Escribe en la LCD el caracter "@"
--
--
-- CODIGO_FIN() -> Finaliza el código. 
--						 NOTA: Dentro de los paréntesis poner cualquier número: 1,2,3,4...,8,9.
--
--
-- BUCLE_INI() -> Indica el inicio de un bucle. 
--						NOTA: Dentro de los paréntesis poner cualquier número: 1,2,3,4...,8,9.
--
--
-- BUCLE_FIN() -> Indica el final del bucle.
--						NOTA: Dentro de los paréntesis poner cualquier número: 1,2,3,4...,8,9.
--
--
-- INT_NUM() -> Escribe en la LCD un número entero.
--					 NOTA: Dentro de los paréntesis poner sólo un número que vaya del 0 al 9,
--						    si se quiere escribir otro número entero se tiene que volver
--							 a llamar la función
--
--
-- CREAR_CHAR() -> Función que crea el caracter diseñado previamente en "CARACTERES_ESPECIALES.vhd"
--                 NOTA: Dentro de los paréntesis poner el nombre del caracter dibujado (CHAR1,CHAR2,CHAR3,..,CHAR8)
--								 
--
-- CHAR_CREADO() -> Escribe en la LCD el caracter creado por medio de la función "CREAR_CHAR()"
--						  NOTA: Dentro de los paréntesis poner el nombre del caracter creado.
--
--     Por ejemplo: 
--
--				Dentro de CARACTERES_ESPECIALES.vhd se dibujan los caracteres personalizados utilizando los vectores 
--				"CHAR_1", "CHAR_2","CHAR_3",...,"CHAR_7","CHAR_8"
--
--								 '1' => [#] - Se activa el pixel de la matríz.
--                       '0' => [ ] - Se desactiva el pixel de la matriz.
--
-- 			Si se quiere crear el				Entonces CHAR_1 queda de la siguiente
--				siguiente caracter:					manera:
--												
--				  1  2  3  4  5						CHAR_1 <=
--  		  1 [ ][ ][ ][ ][ ]							"00000"&			
-- 		  2 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  3 [ ][#][ ][#][ ]							"01010"&   		  
-- 		  4 [ ][ ][ ][ ][ ]		=====>			"00000"&			   
-- 		  5 [#][ ][ ][ ][#]							"10001"&          
-- 		  6 [ ][#][#][#][ ]							"01110"&			  
-- 		  7 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  8 [ ][ ][ ][ ][ ]							"00000";			
--
--		
--			Como el caracter se creó en el vector "CHAR_1",entonces se escribe en las funciónes como "CHAR1"
--			
--			CREAR_CHAR(CHAR1)  -- Crea el caracter personalizado (CHAR1)
--			CHAR_CREADO(CHAR1) -- Muestra en la LCD el caracter creado (CHAR1)		
--
-- 
--
-- LIMPIAR_PANTALLA() -> Manda a limpiar la LCD.
--								 NOTA: Ésta función se activa poniendo dentro de los paréntesis
--										 un '1' y se desactiva con un '0'. 
--
--		Por ejemplo: LIMPIAR_PANTALLA('1') -- Limpiar pantalla está activado.
--						 LIMPIAR_PANTALLA('0') -- Limpiar pantalla está desactivado.
--
--
--	Con los puertos de entrada "CORD" y "CORI" se hacen corrimientos a la derecha y a la
--	izquierda respectivamente. NOTA: La velocidad del corrimiento se puede cambiar 
-- modificando la variable "DELAY_COR".
--
-- Algunas funciónes generan un vector ("BLCD") cuando se terminó de ejecutar dicha función y
--	que puede ser utilizado como una bandera, el vector solo dura un ciclo de instruccion.
--	   
--		LCD_INI() ---------- BLCD <= x"01"
--		CHAR() ------------- BLCD <= x"02"
--		POS() -------------- BLCD <= x"03"
-- 	INT_NUM() ---------- BLCD <= x"04"
--	   CHAR_ASCII() ------- BLCD <= x"05"
--	   BUCLE_INI() -------- BLCD <= x"06"
--		BUCLE_FIN() -------- BLCD <= x"07"
--		LIMPIAR_PANTALLA() - BLCD <= x"08"
--	   CREAR_CHAR() ------- BLCD <= x"09"
--	 	CHAR_CREADO() ------ BLCD <= x"0A"
--
--
--		¡IMPORTANTE!
--		
--		1) Se deberá especificar el número de instrucciones en la constante "NUM_INSTRUCCIONES". El valor 
--			de la última instrucción es el que se colocará
--		2) En caso de utilizar a la librería como TOP del diseño, se deberá comentar el puerto genérico y 
--			descomentar la constante "FPGA_CLK" para especificar la frecuencia de reloj.
--		3) Cada función se acompaña con " INST(NUM) <= <FUNCIÓN> " como lo muestra en el código
-- 		demostrativo.
--
--
--                CÓDIGO DEMOSTRATIVO
--
--		CONSTANT NUM_INSTRUCCIONES : INTEGER := 7;
--
-- 	INST(0) <= LCD_INI("11"); 		-- INICIALIZAMOS LCD, CURSOR A HOME, CURSOR ON, PARPADEO ON.
-- 	INST(1) <= POS(1,1);				-- EMPEZAMOS A ESCRIBIR EN LA LINEA 1, POSICIÓN 1
-- 	INST(2) <= CHAR(MH);				-- ESCRIBIMOS EN LA LCD LA LETRA "h" MAYUSCULA
-- 	INST(3) <= CHAR(O);			
-- 	INST(4) <= CHAR(L);
-- 	INST(5) <= CHAR(A);
-- 	INST(6) <= CHAR_ASCII(x"21"); -- ESCRIBIMOS EL CARACTER "!"
-- 	INST(7) <= CODIGO_FIN(1);	   -- FINALIZAMOS EL CODIGO
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;    -- for uniform & trunc functions
use ieee.numeric_std.all;  -- for to_unsigned function
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- Libreria para sumar 
USE WORK.COMANDOS_LCD_REVD.ALL; --Libreria para LCD

entity LIB_LCD_INTESC_REVD is

GENERIC(
			FPGA_CLK : INTEGER := 100_000_000
);


PORT(CLK: IN STD_LOGIC;

-----------------------------------------------------
------------------PUERTOS DE LA LCD------------------
	  RS 		  : OUT STD_LOGIC;							--
	  RW		  : OUT STD_LOGIC;							--
	  ENA 	  : OUT STD_LOGIC;							--
	  DATA_LCD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   --
-----------------------------------------------------
-----------------------------------------------------
	  
	  
-----------------------------------------------------------
--------------ABAJO ESCRIBE TUS PUERTOS--------------------	
	   D1, D2, S1, B, S, Q : in std_logic;
       LED1, PWM1: out std_logic;
       LED_AUX : out std_logic_vector(7 downto 0) := "00000000"
-----------------------------------------------------------
-----------------------------------------------------------

	  );

end LIB_LCD_INTESC_REVD;

architecture Behavioral of LIB_LCD_INTESC_REVD is


CONSTANT NUM_INSTRUCCIONES : INTEGER := 38; 	--INDICAR EL NÚMERO DE INSTRUCCIONES PARA LA LCD


--------------------------------------------------------------------------------
-------------------------SEÑALES DE LA LCD (NO BORRAR)--------------------------
																										--
component PROCESADOR_LCD_REVD is																--
																										--
GENERIC(																								--
			FPGA_CLK : INTEGER := 50_000_000;												--
			NUM_INST : INTEGER := 1																--
);																										--
																										--
PORT( CLK				 : IN  STD_LOGIC;														--
	   VECTOR_MEM 		 : IN  STD_LOGIC_VECTOR(8  DOWNTO 0);							--
	   C1A,C2A,C3A,C4A : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);							--
	   C5A,C6A,C7A,C8A : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);							--
	   RS 				 : OUT STD_LOGIC;														--
	   RW 				 : OUT STD_LOGIC;														--
	   ENA 				 : OUT STD_LOGIC;														--
	   BD_LCD 			 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);			         	--
	   DATA 				 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);							--
	   DIR_MEM 			 : OUT INTEGER RANGE 0 TO NUM_INSTRUCCIONES					--
	);																									--
																										--
end component PROCESADOR_LCD_REVD;															--
																										--
COMPONENT CARACTERES_ESPECIALES_REVD is													--
																										--
PORT( C1,C2,C3,C4 : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);								--
		C5,C6,C7,C8 : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)									--
	 );																								--
																										--
end COMPONENT CARACTERES_ESPECIALES_REVD;													--
																										--
CONSTANT CHAR1 : INTEGER := 1;																--
CONSTANT CHAR2 : INTEGER := 2;																--
CONSTANT CHAR3 : INTEGER := 3;																--
CONSTANT CHAR4 : INTEGER := 4;																--
CONSTANT CHAR5 : INTEGER := 5;																--
CONSTANT CHAR6 : INTEGER := 6;																--
CONSTANT CHAR7 : INTEGER := 7;																--
CONSTANT CHAR8 : INTEGER := 8;																--
																										--
type ram is array (0 to  NUM_INSTRUCCIONES) of std_logic_vector(8 downto 0); 	--
signal INST : ram := (others => (others => '0'));										--
																										--
signal blcd 			  : std_logic_vector(7 downto 0):= (others => '0');		--																										
signal vector_mem 	  : STD_LOGIC_VECTOR(8  DOWNTO 0) := (others => '0');		--
signal c1s,c2s,c3s,c4s : std_logic_vector(39 downto 0) := (others => '0');		--
signal c5s,c6s,c7s,c8s : std_logic_vector(39 downto 0) := (others => '0'); 	--
signal dir_mem 		  : integer range 0 to NUM_INSTRUCCIONES := 0;				--
																										--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
component main_pwm is   
port (
    clk100m : in std_logic;
    btn_in  : in std_logic;
    duty_cycle: in integer;
    pwm_out : out std_logic
);
end component;
--------------------------------------------------------------------------------
---------------------------AGREGA TUS SEÑALES AQUÍ------------------------------
signal cont, int_num_D1, int_num_D2, int_total1, aux_int_total, int_aux_total, int_aux_total2, int_aux_total3 : integer := 0;
signal rst, ready, valid : std_logic;
signal flag: std_logic := '0';
signal CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12, CH13, CH14, CH15,
       CH16, CH17, CH18, CH19, CH20, CH21, CH22, CH23, CH24, CH25, CH26, CH27, CH28,
       CH29, CH30, CH31, CH32 : std_logic_vector(7 downto 0);
signal data :std_logic_vector(31 downto 0);
signal duty_cycle1 : integer;
signal total1, aux_total1 : std_logic_vector (7 downto 0) := "00000000";
signal aux_num_D1, aux_num_D2, aux_T1, aux_T2, aux_red_total: std_logic_vector (7 downto 0) := "00110000";
signal num_D1, num_D2 : std_logic_vector(2 downto 0):="000"; -- Números de los dados
signal num_gana: std_logic_vector(7 downto 0) := "00001000"; -- Número ganador 24
type stateType is (E0, E1, E2,E3, E5);
signal currentState, nextState : stateType;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


begin


---------------------------------------------------------------
-------------------COMPONENTES PARA LCD------------------------
																				 --
u1: PROCESADOR_LCD_REVD													 --
GENERIC map( FPGA_CLK => FPGA_CLK,									 --
				 NUM_INST => NUM_INSTRUCCIONES )						 --
																				 --
PORT map( CLK,VECTOR_MEM,C1S,C2S,C3S,C4S,C5S,C6S,C7S,C8S,RS, --
			 RW,ENA,BLCD,DATA_LCD, DIR_MEM );						 --
																				 --
U2 : CARACTERES_ESPECIALES_REVD 										 --
PORT MAP( C1S,C2S,C3S,C4S,C5S,C6S,C7S,C8S );				 		 --
																				 --
VECTOR_MEM <= INST(DIR_MEM);											 --
																				 --
-------------------------------------------------------------------
--------------------ESCRIBE TU CÓDIGO DE VHDL----------------------
                INST(0) <= LCD_INI("10");
                INST(1) <= BUCLE_INI(1);
                INST(2) <= POS(1,1);
                INST(3) <= CHAR_ASCII(CH1);
                INST(4) <= CHAR_ASCII(CH2);
                INST(5) <= CHAR_ASCII(CH3);
                INST(6) <= CHAR_ASCII(CH4);
                INST(7) <= CHAR_ASCII(CH5);
                INST(8) <= CHAR_ASCII(CH6);
                INST(9) <= CHAR_ASCII(CH7);
                INST(10) <= CHAR_ASCII(CH8);
                INST(11) <= CHAR_ASCII(CH9);
                INST(12) <= CHAR_ASCII(CH10);
                INST(13) <= CHAR_ASCII(CH11);
                INST(14) <= CHAR_ASCII(CH12);
                INST(15) <= CHAR_ASCII(CH13);
                INST(16) <= CHAR_ASCII(CH14);
                INST(18) <= CHAR_ASCII(CH15);
                INST(19) <= CHAR_ASCII(CH16);
                INST(17) <= POS(2,1);
                INST(20) <= CHAR_ASCII(CH17);
                INST(21) <= CHAR_ASCII(CH18);
                INST(22) <= CHAR_ASCII(CH19);
                INST(23) <= CHAR_ASCII(CH20);
                INST(24) <= CHAR_ASCII(CH21);
                INST(25) <= CHAR_ASCII(CH22);
                INST(26) <= CHAR_ASCII(CH23);
                INST(27) <= CHAR_ASCII(CH24);
                INST(28) <= CHAR_ASCII(CH25);
                INST(29) <= CHAR_ASCII(CH26);
                INST(30) <= CHAR_ASCII(CH27);
                INST(31) <= CHAR_ASCII(CH28);
                INST(32) <= CHAR_ASCII(CH29);
                INST(33) <= CHAR_ASCII(CH30);
                INST(34) <= CHAR_ASCII(CH31);
                INST(35) <= CHAR_ASCII(CH32);
                INST(36) <= BUCLE_FIN(1);
                INST(37) <= CODIGO_FIN(1);

 	Servo1 : main_pwm port map(Clk, B, duty_cycle1, PWM1);

    inst_prng: entity work.rng_xoshiro128plusplus
        generic map (
            init_seed => x"0123456789abcdef3141592653589793" )
        port map (
            CLK     => CLK,
            rst       => rst,
            reseed    => '0',
            newseed   => (others => '0'),
            out_ready => ready,
            out_valid => valid,
            out_data  => data);
            
-- Process Número aleatorio dad0 1
process(D1, D2)
begin
if (rising_edge(D1) or rising_edge (D2)) then
    ready <= '1';
    rst <= '0';
    num_D1 <= data(2 downto 0); --Asignación numero del aleatorio
    num_D2 <= data(5 downto 3); --Asignación numero del aleatorio
    if( num_D1 > "100") then
    num_D1 <= data(2 downto 0); --Asignación numero del aleatorio
    end if;
    if( num_D2 > "100") then
    num_D2 <= data(5 downto 3); --Asignación numero del aleatorio
    end if;
end if;
end process;

----Syncrhonous process (State FFs)
syncProcess: process(Rst, Clk)
begin
if rising_edge(clk) then
    currentState <= nextState;
end if;
end process syncProcess;

combProcess: process(currentState, B) --Combinatorial process (State and output decode)

begin
--Combinatorial process (State and output decode)
case currentState is
when E0 => --Modo configuración 

    ---- Servomotores se alinean al centro
    duty_cycle1 <= 75_000;
    ---- Pantalla de inicio
    CH1 <= "01000010";-- B
    CH2 <= "01101001";-- i
    CH3 <= "01100101";-- e
    CH4 <= "01101110";-- n
    CH5 <= "01110110";-- v
    CH6 <= "01100101";-- e
    CH7 <= "01101110";-- n
    CH8 <= "01101001";-- i
    CH9 <= "01100100";-- d
    CH10 <= "01101111";-- o
    CH11 <= "01110011";-- s
    CH12 <= "00100001";-- !
    CH13 <= "00100000";-- espacio
    CH14 <= "00100000";-- espacio
    CH15 <= "00100000";-- espacio
    CH16 <= "00100000";-- espacio
    CH17 <= "00100000";-- espacio
    CH18 <= "00100000";-- espacio
    CH19 <= "00100000";-- espacio
    CH20 <= "00100000";-- espacio
    CH21 <= "00100000";-- espacio
    CH22 <= "00100000";-- espacio
    CH23 <= "00100000";-- espacio
    CH24 <= "00100000";-- espacio
    CH25 <= "00100000";-- esapcio
    CH26 <= "00100000";-- espacio
    CH27 <= "00100000";-- espacio
    CH28 <= "00100000";-- espacio
    CH29 <= "00100000";-- espacio
    CH30 <= "00100000";-- espacio
    CH31 <= "00100000";-- espacio
    CH32 <= "00100000";-- espacio
    if(S1 = '1') then --Activa a un jugador
          LED1 <= '1';
          cont <= 1;
          total1 <= "00000000";
    end if;
          
    if(duty_cycle1 = 25_000) then
        total1 <= "00000000";
    end if;
    
    if (B = '1') then -- Avanza al jugador 1
        nextstate <= E1;
    end if;
    
when E1 => -- Jugador 1
    --Tablero juagdor 1
    CH1 <= "00100000";-- espacio
    CH2 <= "00100000";-- espacio
    CH3 <= "00100000";-- espacio
    CH4 <= "00100000";-- espacio
    CH5 <= "01001010";-- J
    CH6 <= "01110101";-- u
    CH7 <= "01100111";-- g
    CH8 <= "01100001";-- a
    CH9 <= "01100100";-- d
    CH10 <= "01101111";-- o
    CH11 <= "01110010";-- r
    CH12 <= "00100000";-- espacio
    CH13 <= "00110001";-- 1
    CH14 <= "00100000";-- espacio
    CH15 <= "00100000";-- espacio
    CH16 <= "00100000";-- espacio
    CH17 <= "01000100";-- D
    CH18 <= "00110001";-- 1
    CH19 <= "00111010";-- :
    CH20 <= aux_num_D1; -- número aleatorio
    CH21 <= "00100000";-- espacio
    CH22 <= "01000100";-- D
    CH23 <= "00110010";-- 2
    CH24 <= "00111010";-- :
    CH25 <= aux_num_D2; -- número aleatorio
    CH26 <= "00100000";-- espacio
    CH27 <= "01010100";-- T
    CH28 <= "00111010";-- :
    CH29 <= aux_T1;-- Decenas del total
    CH30 <= aux_T2;-- Unidades del total
    CH31 <= "00100000";-- espacio
    CH32 <= "00100000";-- espacio
    
    if (D1 = '1') then
--       int_num_D1 <= 3;
       int_num_D1 <= to_integer(unsigned(num_D1(2 downto 0)));
        aux_num_D1 <= "00110" & num_D1;
--       aux_num_D1 <= "00110011";
    end if;

    if (D2 = '1') then
--          int_num_D2 <= 5;
          int_num_D2 <= to_integer(unsigned(num_D2(2 downto 0)));
           aux_num_D2 <= "00110" & num_D2;
--          aux_num_D2 <= "00110101";
    end if;
     
    if(S = '1') then    
        int_total1 <= int_num_D1 + int_num_D2;
--        int_aux_total3 <= int_aux_total;
--        total1 <= total1 + num_D1 + num_D2; --ERROR DEL SUMATORIA
        if(int_total1 > 9) then
            int_total1 <= int_total1 + 6;
        end if;
--        LED_AUX <= total1;
--        int_total1 <= int_aux_total;
        total1 <= std_logic_vector(to_unsigned(int_total1, total1'length));
        LED_AUX <= total1;
        aux_T1 <= "0011" & total1(7 downto 4);
        aux_T2 <= "0011" & total1(3 downto 0);
        aux_int_total <= 24 - int_total1;
        aux_red_total <= std_logic_vector(to_unsigned(aux_int_total, aux_red_total'length));
        flag <= '1';
        
--        if(total1 = num_gana) then -- Comprobación de si gana el jugador 1
--               -- Desplega que gano el jugador 1
--               CH1 <= "01000111";-- G
--               CH2 <= "01100001";-- a
--               CH3 <= "01101110";-- n
--               CH4 <= "01100001";-- a
--               CH5 <= "01100100";-- d
--               CH6 <= "01101111";-- o
--               CH7 <= "01110010";-- r
--               CH8 <= "00100000";-- espacio
--               CH9 <= "01001010";-- J
--               CH10 <= "01110101";-- u
--               CH11 <= "01100111";-- g
--               CH12 <= "01100001";-- a
--               CH13 <= "01100100";-- d
--               CH14 <= "01101111";-- o
--               CH15 <= "01110010";-- r
--               CH16 <= "00110001";-- 1
--               CH17 <= "00100000";-- espacio
--               CH18 <= "00100000";-- espacio
--               CH19 <= "00100000";-- espacio
--               CH20 <= "00100000";-- espacio
--               CH21 <= "00100000";-- espacio
--               CH22 <= "00100000";-- espacio
--               CH23 <= "00100000";-- espacio
--               CH24 <= "00100000";-- espacio
--               CH25 <= "00100000";-- espacio
--               CH26 <= "00100000";-- espacio
--               CH27 <= "00100000";-- espacio
--               CH28 <= "00100000";-- espacio
--               CH29 <= "00100000";-- espacio
--               CH30 <= "00100000";-- espacio
--               CH31 <= "00100000";-- espacio
--               CH32 <= "00100000";-- espacio
               
--               duty_cycle1 <= 25_000; -- Mueve servo al lado del jugador 1 -90°
--               nextState <= E0; -- Regresa al estado de configuracion
--        end if;
    end if;
    
    if(total1 = num_gana) then
    nextState <= E3;
    end if;
    
    if (B = '1' and flag = '1') then -- Cambia de estado
        nextState <= E2;
    else
        nextState <= E1;
    end if;

when E2 => -- Oportunidad jugador 1
-- Preguntar en el display si quiere seguir jugando
     flag <= '0';
--      if(total1 = num_gana) then -- Comprobación de si gana el jugador 1
--                   -- Desplega que gano el jugador 1
--                   CH1 <= "01000111";-- G
--                   CH2 <= "01100001";-- a
--                   CH3 <= "01101110";-- n
--                   CH4 <= "01100001";-- a
--                   CH5 <= "01100100";-- d
--                   CH6 <= "01101111";-- o
--                   CH7 <= "01110010";-- r
--                   CH8 <= "00100000";-- espacio
--                   CH9 <= "01001010";-- J
--                   CH10 <= "01110101";-- u
--                   CH11 <= "01100111";-- g
--                   CH12 <= "01100001";-- a
--                   CH13 <= "01100100";-- d
--                   CH14 <= "01101111";-- o
--                   CH15 <= "01110010";-- r
--                   CH16 <= "00110001";-- 1
--                   CH17 <= "00100000";-- espacio
--                   CH18 <= "00100000";-- espacio
--                   CH19 <= "00100000";-- espacio
--                   CH20 <= "00100000";-- espacio
--                   CH21 <= "00100000";-- espacio
--                   CH22 <= "00100000";-- espacio
--                   CH23 <= "00100000";-- espacio
--                   CH24 <= "00100000";-- espacio
--                   CH25 <= "00100000";-- espacio
--                   CH26 <= "00100000";-- espacio
--                   CH27 <= "00100000";-- espacio
--                   CH28 <= "00100000";-- espacio
--                   CH29 <= "00100000";-- espacio
--                   CH30 <= "00100000";-- espacio
--                   CH31 <= "00100000";-- espacio
--                   CH32 <= "00100000";-- espacio
                   
--                   duty_cycle1 <= 25_000; -- Mueve servo al lado del jugador 1 -90°
--                   nextState <= E0; -- Regresa al estado de configuracion
--            end if;
            
     CH1 <= "01010110";-- V
     CH2 <= "01101111";-- o
     CH3 <= "01101100";-- l
     CH4 <= "01110110";-- v
     CH5 <= "01100101";-- e
     CH6 <= "01110010";-- r
     CH7 <= "00100000";-- espacio
     CH8 <= "01100001";-- a
     CH9 <= "00100000";-- espacio
     CH10 <= "01110100";-- t
     CH11 <= "01101001";-- i
     CH12 <= "01110010";-- r
     CH13 <= "01100001";-- a
     CH14 <= "01110010";-- r
     CH15 <= "00111111";-- ?
     CH16 <= "00100000";-- espacio
     CH17 <= "01010011";-- S
     CH18 <= "01101001";-- i
     CH19 <= "00111010";-- :
     CH20 <= "01000010";-- B
     CH21 <= "00100000";-- espacio
     CH22 <= "00100000";-- espacio
     CH23 <= "00100000";-- espacio
     CH24 <= "01001110";-- N
     CH25 <= "01101111";-- o
     CH26 <= "00111010";-- :
     CH27 <= "01010001";-- Q
     CH28 <= "00100000";-- espacio
     CH29 <= "00100000";-- espacio
     CH30 <= "00100000";-- espacio
     CH31 <= "00100000";-- espacio
     CH32 <= "00100000";-- espacio
     
     if (B = '1' and Q = '0') then
        nextState <= E1;
     elsif (B = '0' and Q = '0') then
        nextState <= E2;
     elsif (B = '0' and Q = '1') then
        nextState <= E5;
     end if;
     
when E3 =>

                   -- Desplega que gano el jugador 1
                   CH1 <= "01000111";-- G
                   CH2 <= "01100001";-- a
                   CH3 <= "01101110";-- n
                   CH4 <= "01100001";-- a
                   CH5 <= "01100100";-- d
                   CH6 <= "01101111";-- o
                   CH7 <= "01110010";-- r
                   CH8 <= "00100000";-- espacio
                   CH9 <= "01001010";-- J
                   CH10 <= "01110101";-- u
                   CH11 <= "01100111";-- g
                   CH12 <= "01100001";-- a
                   CH13 <= "01100100";-- d
                   CH14 <= "01101111";-- o
                   CH15 <= "01110010";-- r
                   CH16 <= "00110001";-- 1
                   CH17 <= "00100000";-- espacio
                   CH18 <= "00100000";-- espacio
                   CH19 <= "00100000";-- espacio
                   CH20 <= "00100000";-- espacio
                   CH21 <= "00100000";-- espacio
                   CH22 <= "00100000";-- espacio
                   CH23 <= "00100000";-- espacio
                   CH24 <= "00100000";-- espacio
                   CH25 <= "00100000";-- espacio
                   CH26 <= "00100000";-- espacio
                   CH27 <= "00100000";-- espacio
                   CH28 <= "00100000";-- espacio
                   CH29 <= "00100000";-- espacio
                   CH30 <= "00100000";-- espacio
                   CH31 <= "00100000";-- espacio
                   CH32 <= "00100000";-- espacio
                   
                   duty_cycle1 <= 25_000; -- Mueve servo al lado del jugador 1 -90°
                   nextState <= E0; -- Regresa al estado de configuracion


when E5 =>

     CH1 <= "01010110";-- V
     CH2 <= "01110101";-- u
     CH3 <= "01100101";-- e
     CH4 <= "01101100";-- l
     CH5 <= "01110110";-- v
     CH6 <= "01100101";-- e
     CH7 <= "00100000";-- espacio
     CH8 <= "01100001";-- a
     CH9 <= "00100000";-- espacio
     CH10 <= "00100000";-- espacio
     CH11 <= "00100000";-- espacio
     CH12 <= "00100000";-- espacio
     CH13 <= "00100000";-- espacio
     CH14 <= "00100000";-- espacio
     CH15 <= "00100000";-- espacio
     CH16 <= "00100000";-- espacio
     CH17 <= "01101001";-- i
     CH18 <= "01101110";-- n
     CH19 <= "01110100";-- t
     CH20 <= "01100101";-- e
     CH21 <= "01101110";-- n
     CH22 <= "01110100";-- t
     CH23 <= "01100001";-- a
     CH24 <= "01110010";-- r
     CH25 <= "00111010";-- :
     CH26 <= "01000010";-- B
     CH27 <= "00100000";-- espacio
     CH28 <= "00100000";-- espacio
     CH29 <= "00100000";-- espacio
     CH30 <= aux_red_total;-- espacio
     CH31 <= "00100000";-- espacio
     CH32 <= "00100000";-- espacio
     
     if(B = '1') then
     nextState <= E0;
     else
     nextState <= E5;
     end if;
    
when others => 
nextstate <= E0;
 
end case;
end process combprocess;
end Behavioral;

-------------------------------------------------------------------
-------------------------------------------------------------------