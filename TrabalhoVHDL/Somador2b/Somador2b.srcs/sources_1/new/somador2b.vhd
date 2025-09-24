library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;   

entity somador2b is
    Port (
        a    : in  STD_LOGIC_VECTOR (1 downto 0); -- entrada a
        b    : in  STD_LOGIC_VECTOR (1 downto 0); -- entrada b
        soma : out STD_LOGIC_VECTOR (2 downto 0) -- saida soma
    );
end somador2b;

architecture Behavioral of somador2b is
begin
    -- Converte para 3 bits e realiza a soma
    soma <= std_logic_vector(resize(unsigned(a), 3) + resize(unsigned(b), 3));
end Behavioral;