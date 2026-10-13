--------------------------------------------------------------------
-- Testbench Punto 15: Contador BCD de 1 digito, por comportamiento
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_contador_bcd_comportamiento is
end entity tb_contador_bcd_comportamiento;

architecture sim of tb_contador_bcd_comportamiento is

    component contador_bcd_comportamiento is
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            q   : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk_tb, rst_tb, en_tb : std_logic := '0';
    signal q_tb : std_logic_vector(3 downto 0);
    constant PERIODO : time := 10 ns;
    signal fin_sim : boolean := false;

begin

    dut : contador_bcd_comportamiento
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

        for i in 1 to 20 loop
            wait for PERIODO;
            assert (to_integer(unsigned(q_tb)) = i mod 10)
                report "Fallo: secuencia BCD incorrecta" severity error;
        end loop;

        en_tb <= '0';
        wait for PERIODO;
        assert (to_integer(unsigned(q_tb)) = 0)
            report "Fallo: el contador avanzo con enable=0" severity error;

        report "Fin de la simulacion: contador_bcd_comportamiento verificado." severity note;
        fin_sim <= true;
        wait;
    end process;

end architecture sim;
