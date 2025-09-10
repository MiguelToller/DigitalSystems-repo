----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2025 09:12:44
-- Design Name: 
-- Module Name: tb_detector_101 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_detector_101 is
end tb_detector_101;

architecture Behavioral of tb_detector_101 is

    -- Sinais de teste
    signal clk     : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '1';
    signal entrada : STD_LOGIC := '0';
    signal saida   : STD_LOGIC;

    -- Período do clock
    constant clk_period : time := 10 ns;

begin

    -- Instanciação da UUT (Unit Under Test)
    uut: entity work.detector_101
        port map (
            clk     => clk,
            reset   => reset,
            entrada => entrada,
            saida   => saida
        );

    -- Gerador de clock
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Estímulos de teste
    stim_proc: process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';

        -- Sequência de bits para testar "101" (espera-se saída = '1')
        entrada <= '1';
        wait for clk_period;

        entrada <= '0';
        wait for clk_period;

        entrada <= '1';
        wait for clk_period;

        -- Tempo extra para observar a saída
        wait for 5 ns;

        -- Final da simulação
        wait;
    end process;

end Behavioral;