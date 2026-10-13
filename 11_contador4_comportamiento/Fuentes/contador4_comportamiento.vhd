--------------------------------------------------------------------
-- Punto 11: IDEM punto 10 (contador binario de 4 bits) pero
-- descrito POR COMPORTAMIENTO
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador4_comportamiento is
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(3 downto 0)
    );
end entity contador4_comportamiento;

architecture comportamiento of contador4_comportamiento is
    signal q_int : unsigned(3 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_int <= (others => '0');
            elsif en = '1' then
                q_int <= q_int + 1;  -- desborda ciclicamente de forma natural
            end if;
        end if;
    end process;

    q <= std_logic_vector(q_int);

end architecture comportamiento;
