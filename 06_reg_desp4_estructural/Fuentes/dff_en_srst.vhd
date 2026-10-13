--------------------------------------------------------------------
-- Punto 5: Flip-flop D sensible al flanco ascendente de reloj,
-- con reset sincronico y entrada de habilitacion (enable)
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dff_en_srst is
    port(
        clk : in  std_logic;  -- reloj
        rst : in  std_logic;  -- reset sincronico, activo en '1'
        en  : in  std_logic;  -- habilitacion, activa en '1'
        d   : in  std_logic;  -- entrada de datos
        q   : out std_logic   -- salida registrada
    );
end entity dff_en_srst;

architecture comportamiento of dff_en_srst is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= '0';
            elsif en = '1' then
                q <= d;
            end if;
            -- si rst='0' y en='0' el flip-flop mantiene su valor
        end if;
    end process;
end architecture comportamiento;
