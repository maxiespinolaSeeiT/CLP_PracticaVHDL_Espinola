--------------------------------------------------------------------
-- Punto 17: Generador de habilitacion
-- Emite un pulso en '1' durante UN ciclo de reloj cada N ciclos
-- de reloj. Util como "divisor de frecuencia" para generar
-- habilitaciones periodicas (por ejemplo, 1 pulso por segundo).
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity generador_habilitacion is
    generic(
        N : integer := 10  -- periodo del pulso, en cantidad de ciclos de reloj
    );
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;  -- reset sincronico
        habilitacion : out std_logic   -- pulso de 1 ciclo, cada N ciclos
    );
end entity generador_habilitacion;

architecture comportamiento of generador_habilitacion is
    signal contador : integer range 0 to N-1 := 0;
    signal hab_int  : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                contador <= 0;
                hab_int  <= '0';
            elsif contador = N-1 then
                contador <= 0;
                hab_int  <= '1';   -- pulso de habilitacion durante este ciclo
            else
                contador <= contador + 1;
                hab_int  <= '0';
            end if;
        end if;
    end process;

    habilitacion <= hab_int;

end architecture comportamiento;
