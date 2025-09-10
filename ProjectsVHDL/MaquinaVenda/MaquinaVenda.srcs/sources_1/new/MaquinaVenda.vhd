-- Código do maquina_venda.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity maquina_venda is
    Port (
        clk            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        m25            : in  STD_LOGIC;
        m50            : in  STD_LOGIC;
        libera_produto : out STD_LOGIC;
        troco25        : out STD_LOGIC
    );
end maquina_venda;

architecture moore of maquina_venda is
    type state_type is (S0_INICIAL, S25, S50, S75_PRODUTO, S100_TROCO);
    signal estado, prox_estado : state_type;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            estado <= S0_INICIAL;
        elsif rising_edge(clk) then
            estado <= prox_estado;
        end if;
    end process;

    process(estado, m25, m50)
    begin
        libera_produto <= '0';
        troco25 <= '0';
        prox_estado <= estado;
        case estado is
            when S0_INICIAL =>
                if m25 = '1' then prox_estado <= S25;
                elsif m50 = '1' then prox_estado <= S50; end if;
            when S25 =>
                if m25 = '1' then prox_estado <= S50;
                elsif m50 = '1' then prox_estado <= S75_PRODUTO; end if;
            when S50 =>
                if m25 = '1' then prox_estado <= S75_PRODUTO;
                elsif m50 = '1' then prox_estado <= S100_TROCO; end if;
            when S75_PRODUTO =>
                libera_produto <= '1';
                prox_estado <= S0_INICIAL;
            when S100_TROCO =>
                libera_produto <= '1';
                troco25 <= '1';
                prox_estado <= S0_INICIAL;
        end case;
    end process;
end moore;