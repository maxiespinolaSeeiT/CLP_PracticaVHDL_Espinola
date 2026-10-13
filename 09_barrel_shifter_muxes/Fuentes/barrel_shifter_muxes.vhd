--------------------------------------------------------------------
-- Punto 9: Idea e implementacion del barrel shifter usando
-- multiplexores 2x1 (ancho del componente fijo, N=8).
--
-- IDEA:
-- Un barrel shifter de N bits puede armarse como una red de
-- log2(N) etapas en cascada ("log-shifter"). La etapa i desplaza
-- la palabra en 2^i posiciones (rellenando con '0') si el bit i
-- del selector shift_amt esta en '1', o la deja igual si esta en
-- '0'. Cada bit de cada etapa se resuelve con un multiplexor 2x1:
--   entrada a = valor sin desplazar (bit "sel=0")
--   entrada b = valor desplazado 2^i posiciones (bit "sel=1")
--   sel      = shift_amt(i)
-- Para N=8 se necesitan 3 etapas (desplazamientos de 1, 2 y 4),
-- cada una formada por 8 multiplexores 2x1 (uno por bit).
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal: barrel shifter de 8 bits (desplazamiento a
-- derecha, ancho fijo) construido con 3 etapas de muxes 2x1
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity barrel_shifter_muxes is
    port(
        data_in   : in  std_logic_vector(7 downto 0);
        shift_amt : in  std_logic_vector(2 downto 0);  -- 0..7
        data_out  : out std_logic_vector(7 downto 0)
    );
end entity barrel_shifter_muxes;

architecture estructural of barrel_shifter_muxes is

    component mux2to1 is
        port(
            a, b : in  std_logic;
            sel  : in  std_logic;
            y    : out std_logic
        );
    end component;

    signal etapa0, etapa1, etapa2 : std_logic_vector(7 downto 0);
    signal desp0, desp1, desp2    : std_logic_vector(7 downto 0);

begin

    -- Version desplazada (a la derecha, rellenando con 0) para cada etapa
    desp0 <= '0' & data_in(7 downto 1);           -- data_in >> 1
    desp1 <= "00" & etapa0(7 downto 2);           -- etapa0  >> 2
    desp2 <= "0000" & etapa1(7 downto 4);         -- etapa1  >> 4

    -- Etapa 0: desplazamiento de 1 posicion segun shift_amt(0)
    gen_etapa0 : for i in 0 to 7 generate
        m0 : mux2to1 port map(a => data_in(i), b => desp0(i), sel => shift_amt(0), y => etapa0(i));
    end generate gen_etapa0;

    -- Etapa 1: desplazamiento de 2 posiciones segun shift_amt(1)
    gen_etapa1 : for i in 0 to 7 generate
        m1 : mux2to1 port map(a => etapa0(i), b => desp1(i), sel => shift_amt(1), y => etapa1(i));
    end generate gen_etapa1;

    -- Etapa 2: desplazamiento de 4 posiciones segun shift_amt(2)
    gen_etapa2 : for i in 0 to 7 generate
        m2 : mux2to1 port map(a => etapa1(i), b => desp2(i), sel => shift_amt(2), y => etapa2(i));
    end generate gen_etapa2;

    data_out <= etapa2;

end architecture estructural;
