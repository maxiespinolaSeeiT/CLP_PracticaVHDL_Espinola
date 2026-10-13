--------------------------------------------------------------------
-- Punto 14: Contador BCD de 1 digito (0..9), ESTRUCTURAL
-- Armado con: un registro de 4 bits (reset sincronico + enable),
-- un incrementador (sumadores completos) y un comparador que
-- detecta cuando el registro vale 9, para reiniciar la cuenta.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal: contador BCD de 1 digito
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity contador_bcd_estructural is
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(3 downto 0)  -- digito BCD (0..9)
    );
end entity contador_bcd_estructural;

architecture estructural of contador_bcd_estructural is

    component dff_en_srst is
        port(clk, rst, en, d : in std_logic; q : out std_logic);
    end component;

    component sumador_completo is
        port(a, b, cin : in std_logic; s, cout : out std_logic);
    end component;

    component comparador4 is
        port(a, b : in std_logic_vector(3 downto 0); igual : out std_logic);
    end component;

    component mux2to1 is
        port(a, b, sel : in std_logic; y : out std_logic);
    end component;

    signal q_actual, q_inc, q_siguiente : std_logic_vector(3 downto 0);
    signal carry     : std_logic_vector(4 downto 0);
    signal es_nueve  : std_logic;

begin

    -- Incrementador: q_actual + 1
    carry(0) <= '1';
    gen_inc : for i in 0 to 3 generate
        inc : sumador_completo
            port map(a => q_actual(i), b => '0', cin => carry(i),
                      s => q_inc(i), cout => carry(i + 1));
    end generate gen_inc;

    -- Comparador: detecta si q_actual = 9 ("1001")
    comp : comparador4
        port map(a => q_actual, b => "1001", igual => es_nueve);

    -- Multiplexor: si es_nueve='1' el siguiente valor es 0, sino q_inc
    gen_mux : for i in 0 to 3 generate
        m : mux2to1
            port map(a => q_inc(i), b => '0', sel => es_nueve, y => q_siguiente(i));
    end generate gen_mux;

    -- Registro
    gen_reg : for i in 0 to 3 generate
        reg_bit : dff_en_srst
            port map(clk => clk, rst => rst, en => en, d => q_siguiente(i), q => q_actual(i));
    end generate gen_reg;

    q <= q_actual;

end architecture estructural;
