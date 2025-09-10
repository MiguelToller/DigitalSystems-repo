-- Projeto: contador_3b
-- Descrição: Contador de 3 bits implementado como uma FSM de Moore

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador is
    Port (
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        q : out STD_LOGIC_VECTOR(2 downto 0)
    );
end contador;

architecture moore of contador is

    -- Definição dos estados (8 estados para contagem de 0 a 7)
    type state_type is (
        S000, S001, S010, S011,
        S100, S101, S110, S111
    );
    
    signal estado, prox_estado : state_type;

begin

    -- Processo de transição de estados (sincronizado com clock)
    process(clk, reset)
    begin
        if reset = '1' then
            estado <= S000;
        elsif rising_edge(clk) then
            estado <= prox_estado;
        end if;
    end process;

    -- Processo de lógica de saída e definição do próximo estado
    process(estado)
    begin
        case estado is

            when S000 =>
                q <= "000";
                prox_estado <= S001;

            when S001 =>
                q <= "001";
                prox_estado <= S010;

            when S010 =>
                q <= "010";
                prox_estado <= S011;

            when S011 =>
                q <= "011";
                prox_estado <= S100;

            when S100 =>
                q <= "100";
                prox_estado <= S101;

            when S101 =>
                q <= "101";
                prox_estado <= S110;

            when S110 =>
                q <= "110";
                prox_estado <= S111;

            when S111 =>
                q <= "111";
                prox_estado <= S000;

            when others =>
                q <= "000";
                prox_estado <= S000;

        end case;
    end process;

end moore;
