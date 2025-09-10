-- Projeto: PortaSenha
-- Descrição: Porta controlada por sequência de entrada (FSM do tipo Moore)
-- Sequência correta para abrir: 1 ? 1 ? 0 ? 1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity porta_senha is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        entrada : in  STD_LOGIC;
        aberta  : out STD_LOGIC
    );
end porta_senha;

architecture moore of porta_senha is

    -- Definição dos estados
    type state_type is (S0, S1, S11, S110, S1101);
    signal estado, prox_estado : state_type;

begin

    -- Processo de transição de estados (sincronizado com clock)
    process(clk, reset)
    begin
        if reset = '1' then
            estado <= S0;
        elsif rising_edge(clk) then
            estado <= prox_estado;
        end if;
    end process;

    -- Lógica de saída e definição do próximo estado
    process(estado, entrada)
    begin
        -- Saída padrão: porta fechada
        aberta <= '0';

        case estado is

            when S0 =>
                if entrada = '1' then
                    prox_estado <= S1;
                else
                    prox_estado <= S0;
                end if;

            when S1 =>
                if entrada = '1' then
                    prox_estado <= S11;
                else
                    prox_estado <= S0;
                end if;

            when S11 =>
                if entrada = '0' then
                    prox_estado <= S110;
                else
                    prox_estado <= S11;
                end if;

            when S110 =>
                if entrada = '1' then
                    prox_estado <= S1101;
                else
                    prox_estado <= S0;
                end if;

            when S1101 =>
                aberta <= '1'; -- Porta abre!
                if entrada = '1' then
                    prox_estado <= S1;
                else
                    prox_estado <= S0;
                end if;

            when others =>
                prox_estado <= S0;

        end case;
    end process;

end moore;
