--------------------------------------------------------------------
-- Testbench Punto 6: Registro de desplazamiento de 4 bits estructural
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_reg_desp4_estructural is
end entity tb_reg_desp4_estructural;

architecture sim of tb_reg_desp4_estructural is

    component reg_desp4_estructural is
        port(
            clk        : in  std_logic;
            rst        : in  std_logic;
            en         : in  std_logic;
            serial_in  : in  std_logic;
            q          : out std_logic_vector(3 downto 0);
            serial_out : out std_logic
        );
    end component;

    signal clk_tb, rst_tb, en_tb, serial_in_tb, serial_out_tb : std_logic := '0';
    signal q_tb : std_logic_vector(3 downto 0);
    constant PERIODO : time := 10 ns;
    signal fin_sim : boolean := false;

begin

    dut : reg_desp4_estructural
        port map(
            clk        => clk_tb,
            rst        => rst_tb,
            en         => en_tb,
            serial_in  => serial_in_tb,
            q          => q_tb,
            serial_out => serial_out_tb
        );

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
        -- Reset
        rst_tb <= '1'; en_tb <= '1'; serial_in_tb <= '0';
        wait for PERIODO;
        assert (q_tb = "0000") report "Fallo: reset no limpio el registro" severity error;

        rst_tb <= '0';

        -- Se introduce en serie el patron 1,0,1,1 (bit a bit, uno por ciclo)
        serial_in_tb <= '1'; wait for PERIODO;  -- q = 1000
        assert (q_tb = "1000") report "Fallo ciclo 1" severity error;

        serial_in_tb <= '0'; wait for PERIODO;  -- q = 0100
        assert (q_tb = "0100") report "Fallo ciclo 2" severity error;

        serial_in_tb <= '1'; wait for PERIODO;  -- q = 1010
        assert (q_tb = "1010") report "Fallo ciclo 3" severity error;

        serial_in_tb <= '1'; wait for PERIODO;  -- q = 1101
        assert (q_tb = "1101") report "Fallo ciclo 4" severity error;
        assert (serial_out_tb = '1') report "Fallo: serial_out no coincide con LSB" severity error;

        -- Con enable en 0 el registro no debe cambiar
        en_tb <= '0'; serial_in_tb <= '0';
        wait for PERIODO;
        assert (q_tb = "1101") report "Fallo: el registro cambio con enable=0" severity error;

        report "Fin de la simulacion: reg_desp4_estructural verificado." severity note;
        fin_sim <= true;
        wait;
    end process;

end architecture sim;
