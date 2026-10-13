--------------------------------------------------------------------
-- Testbench Punto 17: Generador de habilitacion
-- Se instancia con N=5 para verificar que el pulso aparece
-- exactamente cada 5 ciclos de reloj y dura solo 1 ciclo.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_generador_habilitacion is
end entity tb_generador_habilitacion;

architecture sim of tb_generador_habilitacion is

    constant N : integer := 5;

    component generador_habilitacion is
        generic(
            N : integer := 10
        );
        port(
            clk          : in  std_logic;
            rst          : in  std_logic;
            habilitacion : out std_logic
        );
    end component;

    signal clk_tb, rst_tb, hab_tb : std_logic := '0';
    constant PERIODO : time := 10 ns;
    signal fin_sim : boolean := false;
    signal contador_pulsos : integer := 0;

begin

    dut : generador_habilitacion
        generic map(N => N)
        port map(clk => clk_tb, rst => rst_tb, habilitacion => hab_tb);

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
        rst_tb <= '1';
        wait for PERIODO;
        assert (hab_tb = '0') report "Fallo: pulso activo tras reset" severity error;

        rst_tb <= '0';

        -- Verifica 3 periodos completos: el pulso debe subir en el ciclo N
        -- (ciclos 1..4 = '0', ciclo 5 = '1'), y repetirse cada N ciclos.
        for rep in 1 to 3 loop
            for ciclo in 1 to N-1 loop
                wait for PERIODO;
                assert (hab_tb = '0')
                    report "Fallo: pulso inesperado en ciclo intermedio" severity error;
            end loop;
            wait for PERIODO;
            assert (hab_tb = '1')
                report "Fallo: no aparecio el pulso en el ciclo N" severity error;
        end loop;

        report "Fin de la simulacion: generador_habilitacion (N=5) verificado." severity note;
        fin_sim <= true;
        wait;
    end process;

end architecture sim;
