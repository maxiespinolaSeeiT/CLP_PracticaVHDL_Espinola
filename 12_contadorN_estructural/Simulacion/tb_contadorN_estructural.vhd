--------------------------------------------------------------------
-- Testbench Punto 12: Contador binario generico de N bits, estructural
-- Se instancia con N=6 para probar la genericidad del diseño
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_contadorN_estructural is
end entity tb_contadorN_estructural;

architecture sim of tb_contadorN_estructural is

    constant N : integer := 6;  -- ancho de prueba distinto de 4, para validar genericidad

    component contadorN_estructural is
        generic(
            N : integer := 8
        );
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            q   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal clk_tb, rst_tb, en_tb : std_logic := '0';
    signal q_tb : std_logic_vector(N-1 downto 0);
    constant PERIODO : time := 10 ns;
    signal fin_sim : boolean := false;

begin

    dut : contadorN_estructural
        generic map(N => N)
        port map(clk => clk_tb, rst => rst_tb, en => en_tb, q => q_tb);

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
        rst_tb <= '1'; en_tb <= '1';
        wait for PERIODO;
        assert (to_integer(unsigned(q_tb)) = 0) report "Fallo: reset no limpio" severity error;

        rst_tb <= '0';

        -- Recorre las 2^N combinaciones y verifica el ciclo completo (0..63..0)
        for i in 1 to (2**N) loop
            wait for PERIODO;
            assert (to_integer(unsigned(q_tb)) = i mod (2**N))
                report "Fallo: valor de cuenta incorrecto en contador generico" severity error;
        end loop;

        en_tb <= '0';
        wait for PERIODO;
        assert (to_integer(unsigned(q_tb)) = 0)
            report "Fallo: el contador avanzo con enable=0" severity error;

        report "Fin de la simulacion: contadorN_estructural (N=6) verificado." severity note;
        fin_sim <= true;
        wait;
    end process;

end architecture sim;
