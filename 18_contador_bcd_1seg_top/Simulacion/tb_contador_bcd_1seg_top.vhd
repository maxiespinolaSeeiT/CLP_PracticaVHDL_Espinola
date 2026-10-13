--------------------------------------------------------------------
-- Testbench Punto 18: Contador BCD 1 digito a 1 segundo (top del kit)
--
-- NOTA DE SIMULACION: en el kit real, FREQ_CLK valdria algo como
-- 50_000_000 (50 MHz), generando 1 pulso de habilitacion cada 50
-- millones de ciclos (1 vez por segundo real). Simular eso tomaria
-- demasiado tiempo, asi que aqui se sobreescribe el generic
-- FREQ_CLK por un valor chico (4) para verificar la LOGICA del
-- diseño en tiempos razonables de simulacion: que el contador BCD
-- avanza periodicamente segun el generador de habilitacion, y que
-- el switch de habilitacion general permite congelar y reanudar
-- la cuenta.
--
-- Nota de diseño: al encadenar dos bloques sincronicos (el
-- generador de habilitacion y el contador BCD), existe un retardo
-- de 1 ciclo de reloj entre el momento en que se genera el pulso
-- y el momento en que el contador lo captura. Esto es un
-- comportamiento normal de la logica sincronica y se refleja en
-- los tiempos de verificacion de este testbench.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_contador_bcd_1seg_top is
end entity tb_contador_bcd_1seg_top;

architecture sim of tb_contador_bcd_1seg_top is

    constant FREQ_CLK_SIM : integer := 4;  -- "segundo simulado" = 4 ciclos de reloj

    component contador_bcd_1seg_top is
        generic(
            FREQ_CLK : integer := 50_000_000
        );
        port(
            clk         : in  std_logic;
            rst         : in  std_logic;
            hab_general : in  std_logic;
            leds        : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk_tb, rst_tb, hab_general_tb : std_logic := '0';
    signal leds_tb : std_logic_vector(3 downto 0);
    constant PERIODO : time := 10 ns;
    signal fin_sim : boolean := false;

begin

    dut : contador_bcd_1seg_top
        generic map(FREQ_CLK => FREQ_CLK_SIM)
        port map(clk => clk_tb, rst => rst_tb, hab_general => hab_general_tb, leds => leds_tb);

    proc_clk : process
    begin
        while not fin_sim loop
            clk_tb <= '0'; wait for PERIODO / 2;
            clk_tb <= '1'; wait for PERIODO / 2;
        end loop;
        wait;
    end process;

    proc_estimulos : process
    begin
        -- Reset general
        rst_tb <= '1'; hab_general_tb <= '1';
        wait for PERIODO;
        assert (to_integer(unsigned(leds_tb)) = 0)
            report "Fallo: reset no limpio el contador" severity error;

        rst_tb <= '0';

        -- Con hab_general='1' la cuenta avanza periodicamente.
        -- Tras 25 ciclos deberia haber avanzado 6 veces (segun el
        -- periodo de FREQ_CLK_SIM ciclos y la latencia de 1 ciclo
        -- entre el generador de habilitacion y el contador).
        wait for 25 * PERIODO;
        assert (to_integer(unsigned(leds_tb)) = 6)
            report "Fallo: la cuenta BCD no avanzo correctamente con hab_general=1" severity error;

        -- Se apaga la habilitacion general: la cuenta debe permanecer
        -- congelada en el mismo valor durante todo este periodo
        hab_general_tb <= '0';
        wait for 12 * PERIODO;
        assert (to_integer(unsigned(leds_tb)) = 6)
            report "Fallo: la cuenta siguio avanzando con hab_general=0" severity error;

        -- Se reactiva la habilitacion general: debe retomar la cuenta
        hab_general_tb <= '1';
        wait for 6 * PERIODO;
        assert (to_integer(unsigned(leds_tb)) = 7)
            report "Fallo: la cuenta no se reanudo tras reactivar hab_general" severity error;

        report "Fin de la simulacion: contador_bcd_1seg_top verificado." severity note;
        fin_sim <= true;
        wait;
    end process;

end architecture sim;
