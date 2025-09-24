library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity semaforo is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        btn      : in  STD_LOGIC;
        verde    : out STD_LOGIC;
        amarelo  : out STD_LOGIC;
        vermelho : out STD_LOGIC
    );
end semaforo;

architecture Behavioral of semaforo is
    type state_type is (S_VERDE, S_AMARELO, S_VERMELHO1, S_VERMELHO2);
    signal state, next_state : state_type;
    signal ped_request : STD_LOGIC := '0';  -- guarda pedido do pedestre
begin
    -- Registrador de estado
    process(clk, reset)
    begin
        if reset = '1' then
            state <= S_VERDE;
            ped_request <= '0';
        elsif rising_edge(clk) then
            state <= next_state;

            -- Memoriza botao se estiver no verde
            if state = S_VERDE and btn = '1' then
                ped_request <= '1';
            elsif state = S_VERMELHO2 then
                ped_request <= '0'; -- limpa apos o vermelho extra
            end if;
        end if;
    end process;
    
    -- Logica de transicao
    process(state, ped_request)
    begin
        case state is
            when S_VERDE =>
                next_state <= S_AMARELO;

            when S_AMARELO =>
                next_state <= S_VERMELHO1;

            when S_VERMELHO1 =>
                if ped_request = '1' then
                    next_state <= S_VERMELHO2;  -- se pedestre pediu
                else
                    next_state <= S_VERDE;      -- ciclo normal
                end if;

            when S_VERMELHO2 =>
                next_state <= S_VERDE;          -- final do ciclo com pedestre
        end case;
    end process;

    -- Saidas
    process(state)
    begin
        verde    <= '0';
        amarelo  <= '0';
        vermelho <= '0';

        case state is
            when S_VERDE =>
                verde <= '1';
            when S_AMARELO =>
                amarelo <= '1';
            when S_VERMELHO1 | S_VERMELHO2 =>
                vermelho <= '1';
        end case;
    end process;
end Behavioral;