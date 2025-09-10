library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_porta_senha is
end tb_porta_senha;

architecture Behavioral of tb_porta_senha is

    -- Sinais para instanciar o DUT
    signal clk_tb     : STD_LOGIC := '0';
    signal reset_tb   : STD_LOGIC := '0';
    signal entrada_tb : STD_LOGIC := '0';
    signal aberta_tb  : STD_LOGIC;

    -- Clock period
    constant clk_period : time := 10 ns;

    -- DUT (Device Under Test)
    component porta_senha
        Port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            entrada : in  STD_LOGIC;
            aberta  : out STD_LOGIC
        );
    end component;

begin

    -- Instanciação do componente
    uut: porta_senha
        port map (
            clk     => clk_tb,
            reset   => reset_tb,
            entrada => entrada_tb,
            aberta  => aberta_tb
        );

    -- Geração do clock
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Processo de estímulo
    stim_proc : process
    begin
        -- Aplicar reset
        reset_tb <= '1';
        wait for 2 * clk_period;
        reset_tb <= '0';
        wait for clk_period;

        -- Sequência correta: 1 -> 1 -> 0 -> 1
        entrada_tb <= '1'; wait for clk_period;
        entrada_tb <= '1'; wait for clk_period;
        entrada_tb <= '0'; wait for clk_period;
        entrada_tb <= '1'; wait for clk_period;

        -- Esperar e observar se a porta abriu
        wait for clk_period;

        -- Inserir erro no início (ex: 0) e depois sequência correta
        entrada_tb <= '0'; wait for clk_period;  -- erro: volta pra S0
        entrada_tb <= '1'; wait for clk_period;
        entrada_tb <= '1'; wait for clk_period;
        entrada_tb <= '0'; wait for clk_period;
        entrada_tb <= '1'; wait for clk_period;

        -- Esperar e verificar se a porta abre novamente
        wait for clk_period;

        -- Teste com erro no meio da sequência
        entrada_tb <= '1'; wait for clk_period;
        entrada_tb <= '0'; wait for clk_period;  -- erro: volta pra S0
        entrada_tb <= '1'; wait for clk_period;
        entrada_tb <= '1'; wait for clk_period;
        entrada_tb <= '0'; wait for clk_period;
        entrada_tb <= '1'; wait for clk_period;

        -- Fim do teste
        wait;
    end process;

end Behavioral;
