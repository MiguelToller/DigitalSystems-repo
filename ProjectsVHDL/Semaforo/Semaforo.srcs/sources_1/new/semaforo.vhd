-- Projeto: semaforo
-- Descrição: Implementação de um semáforo simples utilizando uma máquina de estados de Moore

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity semaforo is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        verde    : out STD_LOGIC;
        amarelo  : out STD_LOGIC;
        vermelho : out STD_LOGIC
    );
end semaforo;

architecture moore of semaforo is

    -- Definição dos estados
    type state_type is (SVERDE, SAMARELO, SVERMELHO);
    signal estado, prox_estado : state_type;

begin

    -- Processo de transição de estado
    process(clk, reset)
    begin
        if reset = '1' then
            estado <= SVERDE;
        elsif rising_edge(clk) then
            estado <= prox_estado;
        end if;
    end process;

    -- Processo de lógica de saída e definição do próximo estado
    process(estado)
    begin
        -- Inicialização das saídas
        verde    <= '0';
        amarelo  <= '0';
        vermelho <= '0';

        case estado is
            when SVERDE =>
                verde       <= '1';
                prox_estado <= SAMARELO;

            when SAMARELO =>
                amarelo     <= '1';
                prox_estado <= SVERMELHO;

            when SVERMELHO =>
                vermelho    <= '1';
                prox_estado <= SVERDE;

            when others =>
                prox_estado <= SVERDE;
        end case;
    end process;

end moore;
