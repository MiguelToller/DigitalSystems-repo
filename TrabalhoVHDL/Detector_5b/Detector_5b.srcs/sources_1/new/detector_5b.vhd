library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity detector_5b is
    Port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        din    : in  STD_LOGIC;       -- entrada
        detect : out STD_LOGIC        -- saida 1 quando a sequência = 11010
    );
end detector_5b;

architecture Behavioral of detector_5b is
    type state_type is (S0, S1, S2, S3, S4, S5);
    signal state, next_state : state_type;
begin
    -- Processo de atualizacao do estado
    process(clk, rst)
    begin
        if rst = '1' then
            state <= S0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Logica combinacional
    process(state, din)
    begin
        case state is
            when S0 =>
                if din = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

            when S1 =>
                if din = '1' then
                    next_state <= S2;
                else
                    next_state <= S0;
                end if;

            when S2 =>
                if din = '0' then
                    next_state <= S3;
                else
                    next_state <= S0;
                end if;

            when S3 =>
                if din = '1' then
                    next_state <= S4;
                else
                    next_state <= S0;
                end if;

            when S4 =>
                if din = '0' then
                    next_state <= S5;
                else
                    next_state <= S0;
                end if;

            when S5 =>
                next_state <= S0;  -- sem sobreposicao
        end case;
    end process;

    -- Saida da FSM
    detect <= '1' when state = S5 else '0';

end Behavioral;
