--------------------------------------------------------------------
-- Punto 15: Contador BCD de 1 digito (0..9), descrito POR
-- COMPORTAMIENTO (un unico process que describe el funcionamiento)
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_bcd_comportamiento is
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(3 downto 0)
    );
end entity contador_bcd_comportamiento;

architecture comportamiento of contador_bcd_comportamiento is
    signal q_int : unsigned(3 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_int <= (others => '0');
            elsif en = '1' then
                if q_int = 9 then
                    q_int <= (others => '0');  -- reinicia al llegar a 9
                else
                    q_int <= q_int + 1;
                end if;
            end if;
        end if;
    end process;

    q <= std_logic_vector(q_int);

end architecture comportamiento;
