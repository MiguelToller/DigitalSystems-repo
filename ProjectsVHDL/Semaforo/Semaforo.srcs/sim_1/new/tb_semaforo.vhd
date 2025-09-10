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

    -- Constante de per�odo de clock
    constant clk_period : time := 10 ns;

    -- Componente do sem�foro (UUT)
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

    -- Instancia��o do sem�foro
    uut: semaforo
        port map (
            clk      => clk_tb,
            reset    => reset_tb,
            verde    => verde_tb,
            amarelo  => amarelo_tb,
            vermelho => vermelho_tb
        );

    -- Gera��o do clock
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Est�mulos de teste
    stim_proc : process
    begin
        -- Reset inicial
        reset_tb <= '1';
        wait for 2 * clk_period;
        reset_tb <= '0';

        -- Esperar por algumas transi��es de estado
        wait for 12 * clk_period;

        -- Testar reset durante opera��o
        reset_tb <= '1';
        wait for clk_period;
        reset_tb <= '0';

        -- Esperar mais transi��es
        wait for 10 * clk_period;

        -- Encerrar simula��o
        wait;
    end process;

end Behavioral;