--------------------------------------------------------------------
-- Punto 10: Contador binario de 4 bits, descripcion ESTRUCTURAL
-- Se arma con un registro de 4 flip-flops D (reset sincronico y
-- enable) mas un incrementador construido con sumadores completos
-- (suma el valor actual + "0001").
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal: contador binario de 4 bits
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity contador4_estructural is
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(3 downto 0)
    );
end entity contador4_estructural;

architecture estructural of contador4_estructural is

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

    signal q_actual, q_siguiente : std_logic_vector(3 downto 0);
    signal carry : std_logic_vector(4 downto 0);

begin

    -- Incrementador: q_actual + "0001"
    carry(0) <= '1';  -- se suma 1 (bit menos significativo de "0001")

    gen_incrementador : for i in 0 to 3 generate
        inc : sumador_completo
            port map(
                a    => q_actual(i),
                b    => '0',                 -- el resto de "0001" son ceros
                cin  => carry(i),
                s    => q_siguiente(i),
                cout => carry(i + 1)
            );
    end generate gen_incrementador;

    -- Registro: guarda el valor incrementado en cada flanco de clk
    gen_registro : for i in 0 to 3 generate
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
