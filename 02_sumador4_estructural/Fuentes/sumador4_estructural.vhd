--------------------------------------------------------------------
-- Punto 2: Sumador de 4 bits, descripcion ESTRUCTURAL
-- Se arma encadenando 4 sumadores completos de 1 bit (ripple-carry)
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal: sumador de 4 bits
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sumador4_estructural is
    port(
        a, b : in  std_logic_vector(3 downto 0);
        cin  : in  std_logic;
        s    : out std_logic_vector(3 downto 0);
        cout : out std_logic
    );
end entity sumador4_estructural;

architecture estructural of sumador4_estructural is

    component sumador_completo is
        port(
            a, b, cin : in  std_logic;
            s, cout   : out std_logic
        );
    end component;

    -- Acarreos internos entre etapas
    signal carry : std_logic_vector(4 downto 0);

begin

    carry(0) <= cin;

    -- Generacion de las 4 etapas del sumador (bit 0 = LSB)
    gen_etapas : for i in 0 to 3 generate
        etapa : sumador_completo
            port map(
                a    => a(i),
                b    => b(i),
                cin  => carry(i),
                s    => s(i),
                cout => carry(i + 1)
            );
    end generate gen_etapas;

    cout <= carry(4);

end architecture estructural;
