--------------------------------------------------------------------
-- Punto 7: IDEM punto 6 (registro de desplazamiento de 4 bits a
-- derecha, entrada y salida serie) pero descrito POR COMPORTAMIENTO
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg_desp4_comportamiento is
    port(
        clk        : in  std_logic;
        rst        : in  std_logic;
        en         : in  std_logic;
        serial_in  : in  std_logic;
        q          : out std_logic_vector(3 downto 0);
        serial_out : out std_logic
    );
end entity reg_desp4_comportamiento;

architecture comportamiento of reg_desp4_comportamiento is
    signal q_int : std_logic_vector(3 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_int <= (others => '0');
            elsif en = '1' then
                -- Desplazamiento a derecha: entra serial_in por la izquierda (MSB)
                q_int <= serial_in & q_int(3 downto 1);
            end if;
        end if;
    end process;

    q          <= q_int;
    serial_out <= q_int(0);

end architecture comportamiento;
