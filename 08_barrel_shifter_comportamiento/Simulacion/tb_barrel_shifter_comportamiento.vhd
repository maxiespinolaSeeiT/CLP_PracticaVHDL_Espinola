--------------------------------------------------------------------
-- Testbench Punto 8: Barrel shifter de N bits por comportamiento
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_barrel_shifter_comportamiento is
end entity tb_barrel_shifter_comportamiento;

architecture sim of tb_barrel_shifter_comportamiento is

    constant N     : integer := 8;
    constant SEL_W : integer := 3;

    component barrel_shifter_comportamiento is
        generic(
            N     : integer := 8;
            SEL_W : integer := 3
        );
        port(
            data_in   : in  std_logic_vector(N-1 downto 0);
            shift_amt : in  std_logic_vector(SEL_W-1 downto 0);
            dir       : in  std_logic;
            data_out  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal data_in_tb  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal shift_amt_tb: std_logic_vector(SEL_W-1 downto 0) := (others => '0');
    signal dir_tb      : std_logic := '0';
    signal data_out_tb : std_logic_vector(N-1 downto 0);

begin

    dut : barrel_shifter_comportamiento
        generic map(N => N, SEL_W => SEL_W)
        port map(
            data_in   => data_in_tb,
            shift_amt => shift_amt_tb,
            dir       => dir_tb,
            data_out  => data_out_tb
        );

    process
    begin
        -- 00000001 desplazado 3 a la izquierda -> 00001000
        data_in_tb <= "00000001"; shift_amt_tb <= std_logic_vector(to_unsigned(3, SEL_W)); dir_tb <= '0';
        wait for 10 ns;
        assert (data_out_tb = "00001000") report "Fallo shift izq 3" severity error;

        -- 10000000 desplazado 4 a la derecha -> 00001000
        data_in_tb <= "10000000"; shift_amt_tb <= std_logic_vector(to_unsigned(4, SEL_W)); dir_tb <= '1';
        wait for 10 ns;
        assert (data_out_tb = "00001000") report "Fallo shift der 4" severity error;

        -- Desplazamiento de 0 no cambia nada
        data_in_tb <= "10110110"; shift_amt_tb <= std_logic_vector(to_unsigned(0, SEL_W)); dir_tb <= '0';
        wait for 10 ns;
        assert (data_out_tb = "10110110") report "Fallo shift 0" severity error;

        -- 11111111 desplazado 7 a la derecha -> 00000001
        data_in_tb <= "11111111"; shift_amt_tb <= std_logic_vector(to_unsigned(7, SEL_W)); dir_tb <= '1';
        wait for 10 ns;
        assert (data_out_tb = "00000001") report "Fallo shift der 7" severity error;

        report "Fin de la simulacion: barrel_shifter_comportamiento verificado." severity note;
        wait;
    end process;

end architecture sim;
