--------------------------------------------------------------------------------
-- Ejercicio 16: Contador BCD de 4 digitos con entrada de habilitacion
--
-- * Cuenta de 0000 a 9999 en BCD (cada digito en 4 bits).
-- * rst : reset sincronico, pone el contador en 0000.
-- * ena : habilitacion. Con ena = '0' el contador mantiene su valor.
-- * q   : 16 bits = millares & centenas & decenas & unidades (BCD).
-- * co  : carry out, vale '1' cuando el contador esta en 9999 y ena = '1'
--         (el proximo flanco hace el rollover a 0000). Permite encadenar
--         mas digitos o generar un pulso de desborde.
--
-- Cada digito se incrementa solo si ena = '1' y todos los digitos
-- anteriores valen 9 (acarreo en cascada).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_bcd4d is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        ena : in  std_logic;
        q   : out std_logic_vector(15 downto 0);
        co  : out std_logic
    );
end entity contador_bcd4d;

architecture comportamiento of contador_bcd4d is
    signal uni : unsigned(3 downto 0) := (others => '0');
    signal dec : unsigned(3 downto 0) := (others => '0');
    signal cen : unsigned(3 downto 0) := (others => '0');
    signal mil : unsigned(3 downto 0) := (others => '0');
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                uni <= (others => '0');
                dec <= (others => '0');
                cen <= (others => '0');
                mil <= (others => '0');
            elsif ena = '1' then
                -- Unidades: siempre avanzan cuando hay habilitacion
                if uni = 9 then
                    uni <= (others => '0');
                    -- Decenas: avanzan si las unidades estan en 9
                    if dec = 9 then
                        dec <= (others => '0');
                        -- Centenas: avanzan si unidades y decenas estan en 9
                        if cen = 9 then
                            cen <= (others => '0');
                            -- Millares: avanzan si los tres anteriores estan en 9
                            if mil = 9 then
                                mil <= (others => '0');
                            else
                                mil <= mil + 1;
                            end if;
                        else
                            cen <= cen + 1;
                        end if;
                    else
                        dec <= dec + 1;
                    end if;
                else
                    uni <= uni + 1;
                end if;
            end if;
        end if;
    end process;

    q  <= std_logic_vector(mil) & std_logic_vector(cen) &
          std_logic_vector(dec) & std_logic_vector(uni);

    co <= '1' when (ena = '1' and uni = 9 and dec = 9 and cen = 9 and mil = 9)
          else '0';

end architecture comportamiento;
