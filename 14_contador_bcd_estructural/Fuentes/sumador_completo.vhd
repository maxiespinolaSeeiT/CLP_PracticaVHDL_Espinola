--------------------------------------------------------------------
-- Punto 1: Sumador completo de 1 bit (Full Adder)
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sumador_completo is
    port(
        a, b, cin : in  std_logic;   -- entradas: operandos y acarreo de entrada
        s, cout   : out std_logic    -- salidas: suma y acarreo de salida
    );
end entity sumador_completo;

architecture flujo_datos of sumador_completo is
begin
    s    <= a xor b xor cin;
    cout <= (a and b) or (cin and (a xor b));
end architecture flujo_datos;
