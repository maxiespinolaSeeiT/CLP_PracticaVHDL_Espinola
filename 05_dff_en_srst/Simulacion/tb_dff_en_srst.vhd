--------------------------------------------------------------------
-- Testbench Punto 5: Flip-flop D con reset sincronico y enable
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_dff_en_srst is
end entity tb_dff_en_srst;

architecture sim of tb_dff_en_srst is

    component dff_en_srst is
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            d   : in  std_logic;
            q   : out std_logic
        );
    end component;

    signal clk_tb, rst_tb, en_tb, d_tb, q_tb : std_logic := '0';
    constant PERIODO : time := 10 ns;
    signal fin_sim : boolean := false;

begin

    dut : dff_en_srst
        port map(
            clk => clk_tb,
            rst => rst_tb,
            en  => en_tb,
            d   => d_tb,
            q   => q_tb
        );

    -- Generador de reloj
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
        -- Reset sincronico
        rst_tb <= '1'; en_tb <= '0'; d_tb <= '1';
        wait for PERIODO;
        assert (q_tb = '0') report "Fallo: reset no limpio q" severity error;

        -- Enable en 0: no debe cambiar aunque d cambie
        rst_tb <= '0'; en_tb <= '0'; d_tb <= '1';
        wait for PERIODO;
        assert (q_tb = '0') report "Fallo: q cambio con enable=0" severity error;

        -- Enable en 1: debe capturar d
        en_tb <= '1'; d_tb <= '1';
        wait for PERIODO;
        assert (q_tb = '1') report "Fallo: q no capturo d=1 con enable" severity error;

        d_tb <= '0';
        wait for PERIODO;
        assert (q_tb = '0') report "Fallo: q no capturo d=0 con enable" severity error;

        -- Reset tiene prioridad sobre enable
        en_tb <= '1'; d_tb <= '1'; rst_tb <= '1';
        wait for PERIODO;
        assert (q_tb = '0') report "Fallo: reset no prioriza sobre enable" severity error;

        report "Fin de la simulacion: dff_en_srst verificado." severity note;
        fin_sim <= true;
        wait;
    end process;

end architecture sim;
