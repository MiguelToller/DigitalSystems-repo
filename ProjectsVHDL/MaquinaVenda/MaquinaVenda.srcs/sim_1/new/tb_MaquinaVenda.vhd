-- Código do tb_maquina_venda.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_maquina_venda is
end tb_maquina_venda;

architecture Behavioral of tb_maquina_venda is
    signal clk            : STD_LOGIC := '0';
    signal reset          : STD_LOGIC;
    signal m25            : STD_LOGIC;
    signal m50            : STD_LOGIC;
    signal libera_produto : STD_LOGIC;
    signal troco25        : STD_LOGIC;
    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.maquina_venda
        port map (
            clk => clk, reset => reset, m25 => m25, m50 => m50,
            libera_produto => libera_produto, troco25 => troco25
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stimulus_process : process
    begin
        reset <= '1'; m25 <= '0'; m50 <= '0';
        wait for 2 * CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Teste 1: Pagamento exato (50c + 25c)
        m50 <= '1'; wait for CLK_PERIOD;
        m50 <= '0'; wait for CLK_PERIOD;
        m25 <= '1'; wait for CLK_PERIOD;
        m25 <= '0';
        wait for 5 * CLK_PERIOD;

        -- Teste 2: Pagamento com troco (50c + 50c)
        m50 <= '1'; wait for CLK_PERIOD;
        m50 <= '0'; wait for CLK_PERIOD;
        m50 <= '1'; wait for CLK_PERIOD;
        m50 <= '0';
        wait for 5 * CLK_PERIOD;
        
        wait;
    end process;
end Behavioral;