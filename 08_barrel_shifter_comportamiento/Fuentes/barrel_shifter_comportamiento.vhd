--------------------------------------------------------------------
-- Punto 8: Barrel shifter de N bits, descrito POR COMPORTAMIENTO
-- Desplaza (no rota) data_in una cantidad shift_amt, con direccion
-- configurable, rellenando con ceros. Combinacional (sin reloj).
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter_comportamiento is
    generic(
        N     : integer := 8;  -- ancho de datos
        SEL_W : integer := 3   -- ancho del selector (debe cubrir 0..N-1)
    );
    port(
        data_in   : in  std_logic_vector(N-1 downto 0);
        shift_amt : in  std_logic_vector(SEL_W-1 downto 0);
        dir       : in  std_logic;  -- '0' = izquierda, '1' = derecha
        data_out  : out std_logic_vector(N-1 downto 0)
    );
end entity barrel_shifter_comportamiento;

architecture comportamiento of barrel_shifter_comportamiento is
begin
    process(data_in, shift_amt, dir)
        variable cant : integer;
    begin
        cant := to_integer(unsigned(shift_amt));
        if dir = '0' then
            data_out <= std_logic_vector(shift_left(unsigned(data_in), cant));
        else
            data_out <= std_logic_vector(shift_right(unsigned(data_in), cant));
        end if;
    end process;
end architecture comportamiento;
