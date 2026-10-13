--------------------------------------------------------------------
-- Punto 12: Contador binario GENERICO de N bits, ESTRUCTURAL
-- Mismo esquema que el punto 10 (registro + incrementador con
-- sumadores completos) pero con ancho N parametrizable por generic.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal: contador binario generico de N bits
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity contadorN_estructural is
    generic(
        N : integer := 8  -- ancho del contador, configurable
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity contadorN_estructural;

architecture estructural of contadorN_estructural is

    component dff_en_srst is
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            d   : in  std_logic;
            q   : out std_logic
        );
    end component;

    component sumador_completo is
        port(
            a, b, cin : in  std_logic;
            s, cout   : out std_logic
        );
    end component;

    signal q_actual, q_siguiente : std_logic_vector(N-1 downto 0);
    signal carry : std_logic_vector(N downto 0);

begin

    carry(0) <= '1';  -- se incrementa en 1

    gen_incrementador : for i in 0 to N-1 generate
        inc : sumador_completo
            port map(
                a    => q_actual(i),
                b    => '0',
                cin  => carry(i),
                s    => q_siguiente(i),
                cout => carry(i + 1)
            );
    end generate gen_incrementador;

    gen_registro : for i in 0 to N-1 generate
        reg_bit : dff_en_srst
            port map(
                clk => clk,
                rst => rst,
                en  => en,
                d   => q_siguiente(i),
                q   => q_actual(i)
            );
    end generate gen_registro;

    q <= q_actual;

end architecture estructural;
