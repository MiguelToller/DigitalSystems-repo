library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_semaforo is
end tb_semaforo;

architecture Behavioral of tb_semaforo is

    -- Sinais para conectar ao DUT (Device Under Test)
    signal clk_tb      : STD_LOGIC := '0';
    signal reset_tb    : STD_LOGIC := '0';
    signal verde_tb    : STD_LOGIC;
    signal amarelo_tb  : STD_LOGIC;
    signal vermelho_tb : STD_LOGIC;

    -- Constante de período de clock
    constant clk_period : time := 10 ns;

    -- Componente do semáforo (UUT)
    component semaforo
        Port (
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            verde    : out STD_LOGIC;
            amarelo  : out STD_LOGIC;
            vermelho : out STD_LOGIC
        );
    end component;

begin

    -- Instanciação do semáforo
    uut: semaforo
        port map (
            clk      => clk_tb,
            reset    => reset_tb,
            verde    => verde_tb,
            amarelo  => amarelo_tb,
            vermelho => vermelho_tb
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

    -- Estímulos de teste
    stim_proc : process
    begin
        -- Reset inicial
        reset_tb <= '1';
        wait for 2 * clk_period;
        reset_tb <= '0';

        -- Esperar por algumas transições de estado
        wait for 12 * clk_period;

        -- Testar reset durante operação
        reset_tb <= '1';
        wait for clk_period;
        reset_tb <= '0';

        -- Esperar mais transições
        wait for 10 * clk_period;

        -- Encerrar simulação
        wait;
    end process;

end Behavioral;