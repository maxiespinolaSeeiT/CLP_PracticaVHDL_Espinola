--------------------------------------------------------------------
-- Punto 3: Sumador/Restador de 4 bits, descripcion ESTRUCTURAL
-- Señal de control "sub": '0' = suma (a+b), '1' = resta (a-b)
-- Resta por complemento a 2: a + (not b) + 1  =>  se logra
-- invirtiendo b con XOR(sub) y usando sub como carry-in inicial.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal: sumador/restador de 4 bits
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sumador_restador4 is
    port(
        a, b : in  std_logic_vector(3 downto 0);
        sub  : in  std_logic;                     -- '0' suma, '1' resta
        s    : out std_logic_vector(3 downto 0);
        cout : out std_logic                      -- acarreo / borrow-complementado
    );
end entity sumador_restador4;

architecture estructural of sumador_restador4 is

    component sumador_completo is
        port(
            a, b, cin : in  std_logic;
            s, cout   : out std_logic
        );
    end component;

    signal b_mod : std_logic_vector(3 downto 0);
    signal carry : std_logic_vector(4 downto 0);

begin

    -- Si sub='1' se invierte b (complemento a 1); junto con cin=sub
    -- se completa el complemento a 2 => a - b
    gen_xor : for i in 0 to 3 generate
        b_mod(i) <= b(i) xor sub;
    end generate gen_xor;

    carry(0) <= sub;

    gen_etapas : for i in 0 to 3 generate
        etapa : sumador_completo
            port map(
                a    => a(i),
                b    => b_mod(i),
                cin  => carry(i),
                s    => s(i),
                cout => carry(i + 1)
            );
    end generate gen_etapas;

    cout <= carry(4);

end architecture estructural;
