--------------------------------------------------------------------
-- Punto 4: Multiplexor 2x1
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
    port(
        a, b : in  std_logic;  -- entradas de datos
        sel  : in  std_logic;  -- selector: '0' -> a, '1' -> b
        y    : out std_logic   -- salida
    );
end entity mux2to1;

architecture flujo_datos of mux2to1 is
begin
    y <= a when sel = '0' else b;
end architecture flujo_datos;
