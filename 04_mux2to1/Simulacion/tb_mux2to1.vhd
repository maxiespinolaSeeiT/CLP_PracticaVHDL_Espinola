--------------------------------------------------------------------
-- Testbench Punto 4: Multiplexor 2x1
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_mux2to1 is
end entity tb_mux2to1;

architecture sim of tb_mux2to1 is

    component mux2to1 is
        port(
            a, b : in  std_logic;
            sel  : in  std_logic;
            y    : out std_logic
        );
    end component;

    signal a_tb, b_tb, sel_tb, y_tb : std_logic := '0';

begin

    dut : mux2to1
        port map(
            a   => a_tb,
            b   => b_tb,
            sel => sel_tb,
            y   => y_tb
        );

    process
    begin
        a_tb <= '0'; b_tb <= '1'; sel_tb <= '0'; wait for 10 ns;
        assert (y_tb = '0') report "Fallo sel=0 (debe salir a)" severity error;

        a_tb <= '0'; b_tb <= '1'; sel_tb <= '1'; wait for 10 ns;
        assert (y_tb = '1') report "Fallo sel=1 (debe salir b)" severity error;

        a_tb <= '1'; b_tb <= '0'; sel_tb <= '0'; wait for 10 ns;
        assert (y_tb = '1') report "Fallo sel=0 (debe salir a)" severity error;

        a_tb <= '1'; b_tb <= '0'; sel_tb <= '1'; wait for 10 ns;
        assert (y_tb = '0') report "Fallo sel=1 (debe salir b)" severity error;

        report "Fin de la simulacion: mux2to1 verificado." severity note;
        wait;
    end process;

end architecture sim;
