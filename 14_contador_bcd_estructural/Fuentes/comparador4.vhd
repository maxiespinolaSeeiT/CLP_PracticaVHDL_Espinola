library ieee;
use ieee.std_logic_1164.all;

entity comparador4 is
    port(
        a, b  : in  std_logic_vector(3 downto 0);
        igual : out std_logic
    );
end entity comparador4;

architecture flujo_datos of comparador4 is
    signal bit_igual : std_logic_vector(3 downto 0);
begin
    -- Comparacion bit a bit con XNOR, luego AND de todos los bits
    gen_xnor : for i in 0 to 3 generate
        bit_igual(i) <= a(i) xnor b(i);
    end generate gen_xnor;

    igual <= bit_igual(0) and bit_igual(1) and bit_igual(2) and bit_igual(3);
end architecture flujo_datos;