library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_contador is
end tb_contador;

architecture Behavioral of tb_contador is

    -- Sinais para instanciar o DUT (Device Under Test)
    signal clk_tb   : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '0';
    signal q_tb     : STD_LOGIC_VECTOR(2 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

    -- Componente do contador
    component contador
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            q     : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

begin

    -- Instanciação do contador (DUT)
    uut: contador
        port map (
            clk   => clk_tb,
            reset => reset_tb,
            q     => q_tb
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

        -- Observar 16 ciclos de clock (conta 2 voltas completas de 3 bits)
        wait for 16 * clk_period;

        -- Testar novo reset no meio da contagem
        reset_tb <= '1';
        wait for clk_period;
        reset_tb <= '0';

        -- Mais alguns ciclos após o reset
        wait for 8 * clk_period;

        -- Fim da simulação
        wait;
    end process;

end Behavioral;
