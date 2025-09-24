library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_semaforo is
end tb_semaforo;

architecture sim of tb_semaforo is
    signal clk, reset, btn : STD_LOGIC := '0';
    signal verde, amarelo, vermelho : STD_LOGIC;

    component semaforo
        Port (
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            btn      : in  STD_LOGIC;
            verde    : out STD_LOGIC;
            amarelo  : out STD_LOGIC;
            vermelho : out STD_LOGIC
        );
    end component;

begin
    -- Instancia o semáforo
    UUT: semaforo
        port map (
            clk => clk,
            reset => reset,
            btn => btn,
            verde => verde,
            amarelo => amarelo,
            vermelho => vermelho
        );

    -- Gera clock (10 ns de período)
    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    -- Estímulos
    stim_proc: process
    begin
        -- Reset inicial
        reset <= '1'; wait for 20 ns;
        reset <= '0';

        -- Ciclo normal (sem botão)
        wait for 60 ns;

        -- Ativa botão durante o verde
        btn <= '1'; wait for 10 ns;
        btn <= '0';

        -- Espera o ciclo com vermelho duplo
        wait for 100 ns;

        -- Finaliza simulação
        wait;
    end process;
end sim;
