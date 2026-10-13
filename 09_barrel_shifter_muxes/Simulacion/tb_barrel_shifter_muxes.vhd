--------------------------------------------------------------------
-- Testbench Punto 9: Barrel shifter de 8 bits con muxes 2x1
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_barrel_shifter_muxes is
end entity tb_barrel_shifter_muxes;

architecture sim of tb_barrel_shifter_muxes is

    component barrel_shifter_muxes is
        port(
            data_in   : in  std_logic_vector(7 downto 0);
            shift_amt : in  std_logic_vector(2 downto 0);
            data_out  : out std_logic_vector(7 downto 0)
        );
    end component;

    signal data_in_tb   : std_logic_vector(7 downto 0) := (others => '0');
    signal shift_amt_tb : std_logic_vector(2 downto 0) := (others => '0');
    signal data_out_tb  : std_logic_vector(7 downto 0);

begin

    dut : barrel_shifter_muxes
        port map(
            data_in   => data_in_tb,
            shift_amt => shift_amt_tb,
            data_out  => data_out_tb
        );

    process
    begin
        -- Sin desplazamiento
        data_in_tb <= "10110110"; shift_amt_tb <= "000"; wait for 10 ns;
        assert (data_out_tb = "10110110") report "Fallo shift=0" severity error;

        -- Desplazar 1
        data_in_tb <= "10000000"; shift_amt_tb <= "001"; wait for 10 ns;
        assert (data_out_tb = "01000000") report "Fallo shift=1" severity error;

        -- Desplazar 2
        data_in_tb <= "10000000"; shift_amt_tb <= "010"; wait for 10 ns;
        assert (data_out_tb = "00100000") report "Fallo shift=2" severity error;

        -- Desplazar 4 (etapa 4)
        data_in_tb <= "10000000"; shift_amt_tb <= "100"; wait for 10 ns;
        assert (data_out_tb = "00001000") report "Fallo shift=4" severity error;

        -- Desplazar 7 (combina etapas 1+2+4)
        data_in_tb <= "11111111"; shift_amt_tb <= "111"; wait for 10 ns;
        assert (data_out_tb = "00000001") report "Fallo shift=7" severity error;

        report "Fin de la simulacion: barrel_shifter_muxes verificado." severity note;
        wait;
    end process;

end architecture sim;
