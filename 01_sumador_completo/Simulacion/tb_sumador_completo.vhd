--------------------------------------------------------------------
-- Testbench Punto 1: Sumador completo de 1 bit
-- Prueba exhaustiva de las 8 combinaciones posibles de entrada
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_sumador_completo is
end entity tb_sumador_completo;

architecture sim of tb_sumador_completo is

    component sumador_completo is
        port(
            a, b, cin : in  std_logic;
            s, cout   : out std_logic
        );
    end component;

    signal a_tb, b_tb, cin_tb : std_logic := '0';
    signal s_tb, cout_tb      : std_logic;

begin

    dut : sumador_completo
        port map(
            a    => a_tb,
            b    => b_tb,
            cin  => cin_tb,
            s    => s_tb,
            cout => cout_tb
        );

    process
    begin
        -- Barrido exhaustivo de las 8 combinaciones (a,b,cin)
        a_tb <= '0'; b_tb <= '0'; cin_tb <= '0'; wait for 10 ns;
        assert (s_tb = '0' and cout_tb = '0')
            report "Fallo en 0+0+0" severity error;

        a_tb <= '0'; b_tb <= '0'; cin_tb <= '1'; wait for 10 ns;
        assert (s_tb = '1' and cout_tb = '0')
            report "Fallo en 0+0+1" severity error;

        a_tb <= '0'; b_tb <= '1'; cin_tb <= '0'; wait for 10 ns;
        assert (s_tb = '1' and cout_tb = '0')
            report "Fallo en 0+1+0" severity error;

        a_tb <= '0'; b_tb <= '1'; cin_tb <= '1'; wait for 10 ns;
        assert (s_tb = '0' and cout_tb = '1')
            report "Fallo en 0+1+1" severity error;

        a_tb <= '1'; b_tb <= '0'; cin_tb <= '0'; wait for 10 ns;
        assert (s_tb = '1' and cout_tb = '0')
            report "Fallo en 1+0+0" severity error;

        a_tb <= '1'; b_tb <= '0'; cin_tb <= '1'; wait for 10 ns;
        assert (s_tb = '0' and cout_tb = '1')
            report "Fallo en 1+0+1" severity error;

        a_tb <= '1'; b_tb <= '1'; cin_tb <= '0'; wait for 10 ns;
        assert (s_tb = '0' and cout_tb = '1')
            report "Fallo en 1+1+0" severity error;

        a_tb <= '1'; b_tb <= '1'; cin_tb <= '1'; wait for 10 ns;
        assert (s_tb = '1' and cout_tb = '1')
            report "Fallo en 1+1+1" severity error;

        report "Fin de la simulacion: sumador_completo verificado." severity note;
        wait;
    end process;

end architecture sim;
