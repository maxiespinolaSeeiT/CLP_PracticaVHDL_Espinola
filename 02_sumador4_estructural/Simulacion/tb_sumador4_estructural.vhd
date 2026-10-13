--------------------------------------------------------------------
-- Testbench Punto 2: Sumador de 4 bits estructural
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sumador4_estructural is
end entity tb_sumador4_estructural;

architecture sim of tb_sumador4_estructural is

    component sumador4_estructural is
        port(
            a, b : in  std_logic_vector(3 downto 0);
            cin  : in  std_logic;
            s    : out std_logic_vector(3 downto 0);
            cout : out std_logic
        );
    end component;

    signal a_tb, b_tb, s_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal cin_tb, cout_tb  : std_logic := '0';

    -- Procedimiento auxiliar para verificar un caso
    procedure check(
        a_v, b_v : integer;
        cin_v    : std_logic;
        signal a_s, b_s : out std_logic_vector(3 downto 0);
        signal cin_s    : out std_logic
    ) is
    begin
        a_s   <= std_logic_vector(to_unsigned(a_v, 4));
        b_s   <= std_logic_vector(to_unsigned(b_v, 4));
        cin_s <= cin_v;
    end procedure;

begin

    dut : sumador4_estructural
        port map(
            a    => a_tb,
            b    => b_tb,
            cin  => cin_tb,
            s    => s_tb,
            cout => cout_tb
        );

    process
        variable esperado : integer;
    begin
        -- Casos de prueba: (a, b, cin)
        check(3, 5, '0', a_tb, b_tb, cin_tb);  wait for 10 ns; -- 3+5=8
        assert (to_integer(unsigned(s_tb)) = 8 and cout_tb = '0')
            report "Fallo 3+5+0" severity error;

        check(15, 1, '0', a_tb, b_tb, cin_tb); wait for 10 ns; -- 15+1=16 -> overflow
        assert (to_integer(unsigned(s_tb)) = 0 and cout_tb = '1')
            report "Fallo 15+1+0" severity error;

        check(7, 7, '1', a_tb, b_tb, cin_tb);  wait for 10 ns; -- 7+7+1=15
        assert (to_integer(unsigned(s_tb)) = 15 and cout_tb = '0')
            report "Fallo 7+7+1" severity error;

        check(0, 0, '0', a_tb, b_tb, cin_tb);  wait for 10 ns; -- 0+0=0
        assert (to_integer(unsigned(s_tb)) = 0 and cout_tb = '0')
            report "Fallo 0+0+0" severity error;

        check(9, 9, '1', a_tb, b_tb, cin_tb);  wait for 10 ns; -- 9+9+1=19 -> 3 con carry
        assert (to_integer(unsigned(s_tb)) = 3 and cout_tb = '1')
            report "Fallo 9+9+1" severity error;

        report "Fin de la simulacion: sumador4_estructural verificado." severity note;
        wait;
    end process;

end architecture sim;
