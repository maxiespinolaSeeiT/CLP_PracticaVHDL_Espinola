--------------------------------------------------------------------
-- Punto 18: Contador BCD de 1 digito, avanzando 1 vez por segundo,
-- con habilitacion general controlada por un switch.
-- Pensado para implementarse en el kit de desarrollo, mostrando
-- la cuenta en 4 LEDs.
--
-- Estructura:
--   generador_habilitacion (punto 17) -> genera 1 pulso por segundo
--                                          a partir del reloj del kit
--   AND con el switch de habilitacion general -> habilita o congela
--                                          la cuenta a voluntad
--   contador_bcd_comportamiento (punto 15) -> cuenta BCD 0..9
--
-- El generic FREQ_CLK debe configurarse con la frecuencia real del
-- reloj del kit (en Hz) para que el pulso se genere efectivamente
-- una vez por segundo. Por ejemplo, para un reloj de 50 MHz:
-- FREQ_CLK => 50_000_000.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Entidad principal (TOP) para el kit de desarrollo
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity contador_bcd_1seg_top is
    generic(
        FREQ_CLK : integer := 50_000_000  -- frecuencia del reloj del kit, en Hz
    );
    port(
        clk          : in  std_logic;                     -- reloj del kit
        rst          : in  std_logic;                     -- boton de reset
        hab_general  : in  std_logic;                     -- switch: habilitacion general
        leds         : out std_logic_vector(3 downto 0)   -- 4 LEDs con la cuenta BCD
    );
end entity contador_bcd_1seg_top;

architecture estructural of contador_bcd_1seg_top is

    component generador_habilitacion is
        generic(N : integer := 10);
        port(clk, rst : in std_logic; habilitacion : out std_logic);
    end component;

    component contador_bcd_comportamiento is
        port(clk, rst, en : in std_logic; q : out std_logic_vector(3 downto 0));
    end component;

    signal pulso_1seg     : std_logic;
    signal en_contador    : std_logic;

begin

    -- Genera un pulso de habilitacion cada 1 segundo
    gen_hab : generador_habilitacion
        generic map(N => FREQ_CLK)
        port map(clk => clk, rst => rst, habilitacion => pulso_1seg);

    -- El switch de habilitacion general permite congelar la cuenta
    en_contador <= pulso_1seg and hab_general;

    -- Contador BCD que avanza 1 por segundo cuando hab_general='1'
    cont_bcd : contador_bcd_comportamiento
        port map(clk => clk, rst => rst, en => en_contador, q => leds);

end architecture estructural;
