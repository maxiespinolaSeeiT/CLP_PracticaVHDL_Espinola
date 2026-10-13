--------------------------------------------------------------------
-- Testbench Punto 3: Sumador/Restador de 4 bits estructural
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sumador_restador4 is
end entity tb_sumador_restador4;

architecture sim of tb_sumador_restador4 is

    component sumador_restador4 is
        port(
            a, b : in  std_logic_vector(3 downto 0);
            sub  : in  std_logic;
            s    : out std_logic_vector(3 downto 0);
            cout : out std_logic
        );
    end component;

    signal a_tb, b_tb, s_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal sub_tb, cout_tb  : std_logic := '0';

begin

    dut : sumador_restador4
        port map(
            a    => a_tb,
            b    => b_tb,
            sub  => sub_tb,
            s    => s_tb,
            cout => cout_tb
        );

    process
    begin
        -- SUMA: 3 + 5 = 8
        a_tb <= std_logic_vector(to_unsigned(3, 4));
        b_tb <= std_logic_vector(to_unsigned(5, 4));
        sub_tb <= '0';
        wait for 10 ns;
        assert (to_integer(unsigned(s_tb)) = 8)
            report "Fallo suma 3+5" severity error;

        -- RESTA: 9 - 4 = 5 (sin pedir prestado -> cout=1)
        a_tb <= std_logic_vector(to_unsigned(9, 4));
        b_tb <= std_logic_vector(to_unsigned(4, 4));
        sub_tb <= '1';
        wait for 10 ns;
        assert (to_integer(unsigned(s_tb)) = 5 and cout_tb = '1')
            report "Fallo resta 9-4" severity error;

        -- RESTA: 4 - 9 = -5 (pide prestado -> cout=0, resultado en complemento a 2)
        a_tb <= std_logic_vector(to_unsigned(4, 4));
        b_tb <= std_logic_vector(to_unsigned(9, 4));
        sub_tb <= '1';
        wait for 10 ns;
        assert (to_integer(signed(s_tb)) = -5 and cout_tb = '0')
            report "Fallo resta 4-9" severity error;

        -- RESTA: 6 - 6 = 0
        a_tb <= std_logic_vector(to_unsigned(6, 4));
        b_tb <= std_logic_vector(to_unsigned(6, 4));
        sub_tb <= '1';
        wait for 10 ns;
        assert (to_integer(unsigned(s_tb)) = 0 and cout_tb = '1')
            report "Fallo resta 6-6" severity error;

        -- SUMA con overflow: 15 + 2 = 17 -> 1 con carry
        a_tb <= std_logic_vector(to_unsigned(15, 4));
        b_tb <= std_logic_vector(to_unsigned(2, 4));
        sub_tb <= '0';
        wait for 10 ns;
        assert (to_integer(unsigned(s_tb)) = 1 and cout_tb = '1')
            report "Fallo suma 15+2" severity error;

        report "Fin de la simulacion: sumador_restador4 verificado." severity note;
        wait;
    end process;

end architecture sim;
