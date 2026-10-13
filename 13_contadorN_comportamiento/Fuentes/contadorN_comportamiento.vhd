--------------------------------------------------------------------
-- Punto 13: IDEM punto 12 (contador binario generico de N bits)
-- pero descrito POR COMPORTAMIENTO
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contadorN_comportamiento is
    generic(
        N : integer := 8
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity contadorN_comportamiento;

architecture comportamiento of contadorN_comportamiento is
    signal q_int : unsigned(N-1 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_int <= (others => '0');
            elsif en = '1' then
                q_int <= q_int + 1;
            end if;
        end if;
    end process;

    q <= std_logic_vector(q_int);

end architecture comportamiento;
