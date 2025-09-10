`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2025 08:47:35
// Design Name: 
// Module Name: detector_101b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module detector_101b(
Port (
    clk : in STD_LOGIC; -- Clock
    reset : in STD_LOGIC; -- Reset síncrono-ativo-alto
    entrada : in STD_LOGIC; -- Entrada serial de bits
    saida : out STD_LOGIC -- Saída = '1' quando "101" detectado
    );
endmodule

architecture Behavioral of detector_101 is
    -- Tipo enumerado para representar os estados
    type state_type is (S0, S1, S2, S3);
    signal estado, prox_estado : state_type;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            estado <= S0; -- Estado inicial
        elsif rising_edge(clk) then
            estado <= prox_estado; -- Atualiza estado
        end if;
    end process;
    
    --------------------------------------------------------------------
    -- Processo 2: Lógica combinacional (próximo estado + saída)
    --------------------------------------------------------------------
    process(estado, entrada)
    begin
        saida <= '0'; -- Valor padrão da saída
        
        case estado is
            when S0 =>
                if entrada = '1' then
                    prox_estado <= S1;
                else
                    prox_estado <= S0;
                end if;
            when S1 =>
                if entrada = '0' then
                    prox_estado <= S2;
                else
                    prox_estado <= S1;
                end if;
            when S2 =>
                if entrada = '1' then
                    prox_estado <= S3;
                else
                    prox_estado <= S0;
                end if;
            when S3 =>
                saida <= '1'; -- Sequência 101 detectada
                if entrada = '1' then
                    prox_estado <= S1;
                else
                    prox_estado <= S2;
                end if;
                
            end case;
        end process;
end Behavioral;

                
            


