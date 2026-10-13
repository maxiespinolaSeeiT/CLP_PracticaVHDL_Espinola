--------------------------------------------------------------------------------
-- Testbench del ejercicio 16: contador BCD de 4 digitos con habilitacion
--
-- Verificacion autochequeante contra un modelo de referencia (integer):
--   1) Reset inicial.
--   2) Cuenta completa 0000..9999 y rollover a 0000 con ena = '1'.
--   3) Con ena = '0' el contador mantiene el valor.
--   4) Reset sincronico en medio de la cuenta.
-- Si todo esta bien imprime "SIMULACION OK" al final.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_contador_bcd4d is
end entity tb_contador_bcd4d;

architecture sim of tb_contador_bcd4d is

    constant T_CLK : time := 10 ns;

    signal clk  : std_logic := '0';
    signal rst  : std_logic := '0';
    signal ena  : std_logic := '0';
    signal q    : std_logic_vector(15 downto 0);
    signal co   : std_logic;
    signal fin  : boolean := false;

    -- Convierte un entero 0..9999 al valor BCD de 16 bits esperado
    function a_bcd(n : natural) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned((n / 1000) mod 10, 4)) &
               std_logic_vector(to_unsigned((n / 100)  mod 10, 4)) &
               std_logic_vector(to_unsigned((n / 10)   mod 10, 4)) &
               std_logic_vector(to_unsigned( n         mod 10, 4));
    end function;

begin

    -- Dispositivo bajo prueba
    dut : entity work.contador_bcd4d
        port map (clk => clk, rst => rst, ena => ena, q => q, co => co);

    -- Generador de reloj
    clk <= not clk after T_CLK / 2 when not fin else clk;

    -- Estimulos y verificacion
    estimulos : process
        variable esperado : natural := 0;
    begin
        -- 1) Reset inicial
        rst <= '1';
        ena <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;
        assert q = a_bcd(0)
            report "Error: el reset no puso el contador en 0000" severity failure;
        rst <= '0';

        -- 2) Con ena = '0' no debe contar
        for i in 1 to 5 loop
            wait until rising_edge(clk);
        end loop;
        wait for 1 ns;
        assert q = a_bcd(0)
            report "Error: conto con ena = 0" severity failure;

        -- 3) Cuenta completa 0000..9999 y rollover (10001 flancos)
        ena <= '1';
        esperado := 0;
        for i in 1 to 10001 loop
            wait until rising_edge(clk);
            wait for 1 ns;
            esperado := (esperado + 1) mod 10000;
            assert q = a_bcd(esperado)
                report "Error de cuenta. Esperado = " & integer'image(esperado) &
                       " obtenido (hex) = " & integer'image(to_integer(unsigned(q)))
                severity failure;
        end loop;
        -- Tras 10001 flancos el valor esperado es 0001
        assert esperado = 1 report "Error en el modelo de referencia" severity failure;

        -- 4) Pausa con ena = '0' en medio de la cuenta
        ena <= '0';
        for i in 1 to 5 loop
            wait until rising_edge(clk);
            wait for 1 ns;
            assert q = a_bcd(esperado)
                report "Error: el contador no mantuvo el valor con ena = 0"
                severity failure;
        end loop;

        -- 5) Verificacion del carry out en 9999
        ena <= '1';
        for i in 1 to 9998 loop        -- de 0001 a 9999
            wait until rising_edge(clk);
        end loop;
        wait for 1 ns;
        assert q = a_bcd(9999)
            report "Error: no llego a 9999" severity failure;
        assert co = '1'
            report "Error: co deberia valer 1 en 9999" severity failure;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert q = a_bcd(0) and co = '0'
            report "Error: rollover 9999 -> 0000" severity failure;

        -- 6) Reset sincronico en medio de la cuenta
        for i in 1 to 123 loop
            wait until rising_edge(clk);
        end loop;
        wait for 1 ns;
        assert q = a_bcd(123)
            report "Error: no llego a 0123" severity failure;
        rst <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert q = a_bcd(0)
            report "Error: reset sincronico no funciono" severity failure;
        rst <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert q = a_bcd(1)
            report "Error: no reanudo la cuenta tras el reset" severity failure;

        report "SIMULACION OK" severity note;
        fin <= true;
        wait;
    end process;

end architecture sim;
