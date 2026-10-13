--------------------------------------------------------------------
-- Punto 6: Registro de desplazamiento de 4 bits a derecha,
-- entrada serie y salida serie, descripcion ESTRUCTURAL
-- utilizando el flip-flop del punto 5 (dff_en_srst)
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal: registro de desplazamiento de 4 bits a derecha
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg_desp4_estructural is
    port(
        clk         : in  std_logic;
        rst         : in  std_logic;
        en          : in  std_logic;
        serial_in   : in  std_logic;                     -- entra por el bit mas significativo
        q           : out std_logic_vector(3 downto 0);  -- estado completo del registro
        serial_out  : out std_logic                       -- sale por el bit menos significativo
    );
end entity reg_desp4_estructural;

architecture estructural of reg_desp4_estructural is

    component dff_en_srst is
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            d   : in  std_logic;
            q   : out std_logic
        );
    end component;

    signal q_int : std_logic_vector(3 downto 0);

begin

    -- Desplazamiento a derecha: q(3) <- serial_in, q(2) <- q(3), q(1) <- q(2), q(0) <- q(1)
    ff3 : dff_en_srst port map(clk => clk, rst => rst, en => en, d => serial_in, q => q_int(3));
    ff2 : dff_en_srst port map(clk => clk, rst => rst, en => en, d => q_int(3),  q => q_int(2));
    ff1 : dff_en_srst port map(clk => clk, rst => rst, en => en, d => q_int(2),  q => q_int(1));
    ff0 : dff_en_srst port map(clk => clk, rst => rst, en => en, d => q_int(1),  q => q_int(0));

    q          <= q_int;
    serial_out <= q_int(0);

end architecture estructural;
