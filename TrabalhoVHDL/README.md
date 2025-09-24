<div align="center">

# Trabalho VHDL - Sistemas Digitais

</div>

Este repositório contém uma coleção de projetos básicos em VHDL desenvolvidos para a disciplina de Sistemas Digitais, com foco na implementação de Máquinas de Estados Finitos (FSMs). Cada projeto inclui o código-fonte do design, um testbench para simulação e os resultados da simulação.

## Projetos

1.  [Somador 2 Bits](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/TrabalhoVHDL/Somador2b)
2.  [Detector de Sequência (FSM 5 bits)](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/TrabalhoVHDL/Detector_5b)
3.  [Semáforo com Botão de Pedestre](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/TrabalhoVHDL/Semaforo)

---

## 1. Somador 2 Bits

Este projeto implementa um **somador de 2 bits** utilizando operações aritméticas com vetores `STD_LOGIC_VECTOR`.  
O resultado da soma é representado em 3 bits para contemplar o possível carry.

#### Resultados da Simulação

![Simulação do Somador 2b](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/TrabalhoVHDL/Somador2b/somador2b.png)  
*Figura 1: Simulação do Somador 2b mostrando os resultados das somas.*  

#### Código Fonte
<details>
<summary>Clique para ver o código do Design (somador2b.vhd)</summary>

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;   

entity somador2b is
    Port (
        a    : in  STD_LOGIC_VECTOR (1 downto 0); -- entrada a
        b    : in  STD_LOGIC_VECTOR (1 downto 0); -- entrada b
        soma : out STD_LOGIC_VECTOR (2 downto 0) -- saida soma
    );
end somador2b;

architecture Behavioral of somador2b is
begin
    -- Converte para 3 bits e realiza a soma
    soma <= std_logic_vector(resize(unsigned(a), 3) + resize(unsigned(b), 3));
end Behavioral;
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_somador2b.vhd)</summary>

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_somador2b is
end tb_somador2b;

architecture sim of tb_somador2b is
    component somador2b
        Port (
            a    : in  STD_LOGIC_VECTOR (1 downto 0);
            b    : in  STD_LOGIC_VECTOR (1 downto 0);
            soma : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    signal a_tb    : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal b_tb    : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal soma_tb : STD_LOGIC_VECTOR(2 downto 0);
begin
    uut: somador2b port map (
        a => a_tb,
        b => b_tb,
        soma => soma_tb
    );

    stim_proc: process
    begin
        a_tb <= "00"; b_tb <= "00"; wait for 10 ns;
        a_tb <= "01"; b_tb <= "01"; wait for 10 ns;
        a_tb <= "10"; b_tb <= "11"; wait for 10 ns;
        a_tb <= "11"; b_tb <= "11"; wait for 10 ns;
        wait;
    end process;
end sim;
```
</details>

---

## 2. Detector de Sequência (FSM 5 bits)

Este projeto implementa uma **FSM do tipo Moore** para detectar a sequência serial `11010`.  
A saída `detect` é ativada quando a sequência é reconhecida corretamente.

#### Resultados da Simulação

![Simulação do Detector](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/TrabalhoVHDL/Detector_5b/detector_5b.png)
*Figura 2: Simulação do detector mostrando a ativação da saída após a sequência correta.*  

#### Código Fonte

<details>
<summary>Clique para ver o código do Design (detector_5b.vhd)</summary>

```vhdl
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
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_detector_5b.vhd)</summary>

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_detector_5b is
end tb_detector_5b;

architecture sim of tb_detector_5b is
    component detector_5b
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            din    : in  STD_LOGIC;
            detect : out STD_LOGIC
        );
    end component;

    signal clk_tb    : STD_LOGIC := '0';
    signal rst_tb    : STD_LOGIC := '1';
    signal din_tb    : STD_LOGIC := '0';
    signal detect_tb : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;
begin
    -- Instancia o DUT
    uut: detector_5b port map (
        clk => clk_tb,
        rst => rst_tb,
        din => din_tb,
        detect => detect_tb
    );

    -- Gera clock
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc: process
    begin
        -- reset
        rst_tb <= '1'; wait for 20 ns;
        rst_tb <= '0';

        -- sequencia correta: 11010
        din_tb <= '1'; wait for CLK_PERIOD;
        din_tb <= '1'; wait for CLK_PERIOD;
        din_tb <= '0'; wait for CLK_PERIOD;
        din_tb <= '1'; wait for CLK_PERIOD;
        din_tb <= '0'; wait for CLK_PERIOD;

        -- ruido
        din_tb <= '1'; wait for CLK_PERIOD;
        din_tb <= '0'; wait for CLK_PERIOD;
        din_tb <= '1'; wait for CLK_PERIOD;

        -- outra sequencia correta: 11010
        din_tb <= '1'; wait for CLK_PERIOD;
        din_tb <= '1'; wait for CLK_PERIOD;
        din_tb <= '0'; wait for CLK_PERIOD;
        din_tb <= '1'; wait for CLK_PERIOD;
        din_tb <= '0'; wait for CLK_PERIOD;

        wait;
    end process;
end sim;
```
</details>

---

## 3. Semáforo com Botão de Pedestre

Este projeto implementa uma **FSM Moore** que simula o funcionamento de um semáforo com botão para pedestres.  

#### Resultados da Simulação
![Simulação do Semaforo](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/TrabalhoVHDL/Semaforo/semaforo.png)
*Figura 3: Simulação do semáforo mostrando a ativação do botão e o ciclo com vermelho estendido.*  

### Diagrama de Estado

| Estado Atual        | Condição                         | Próximo Estado      |
|-------------------|---------------------------------|------------------|
| S0 (Verde)         | btn=0 após 1 tempo               | S1 (Amarelo)      |
| S0 (Verde)         | btn=1 após 1 tempo               | S1 (Amarelo)      |
| S1 (Amarelo)       | sempre após 1 tempo              | S2 (Vermelho)     |
| S2 (Vermelho)      | ciclo normal, 1 tempo passou     | S0 (Verde)        |
| S2 (Vermelho)      | ciclo com botão, 1 tempo passou  | S3 (Vermelho Extra) |
| S3 (Vermelho Extra)| após 1 tempo                     | S0 (Verde)        |

### Tabela de Estado

| Estado Atual       | Condição       | Próximo Estado      | Saídas (V A R) |
|------------------|----------------|------------------|----------------|
| S0 (Verde)        | após 1 tempo    | S1 (Amarelo)      | 1 0 0          |
| S1 (Amarelo)      | após 1 tempo    | S2 (Vermelho)     | 0 1 0          |
| S2 (Vermelho)     | btn=0           | S0 (Verde)        | 0 0 1          |
| S2 (Vermelho)     | btn=1           | S3 (VermelhoX)    | 0 0 1          |
| S3 (VermelhoX)    | após 1 tempo    | S0 (Verde)        | 0 0 1          |

#### Código Fonte
<details>
<summary>Clique para ver o código do Design (semaforo.vhd)</summary>

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity semaforo is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        btn      : in  STD_LOGIC;
        verde    : out STD_LOGIC;
        amarelo  : out STD_LOGIC;
        vermelho : out STD_LOGIC
    );
end semaforo;

architecture Behavioral of semaforo is
    type state_type is (S_VERDE, S_AMARELO, S_VERMELHO1, S_VERMELHO2);
    signal state, next_state : state_type;
    signal ped_request : STD_LOGIC := '0';  -- guarda pedido do pedestre
begin
    -- Registrador de estado
    process(clk, reset)
    begin
        if reset = '1' then
            state <= S_VERDE;
            ped_request <= '0';
        elsif rising_edge(clk) then
            state <= next_state;

            -- Memoriza botao se estiver no verde
            if state = S_VERDE and btn = '1' then
                ped_request <= '1';
            elsif state = S_VERMELHO2 then
                ped_request <= '0'; -- limpa apos o vermelho extra
            end if;
        end if;
    end process;
    
    -- Logica de transicao
    process(state, ped_request)
    begin
        case state is
            when S_VERDE =>
                next_state <= S_AMARELO;

            when S_AMARELO =>
                next_state <= S_VERMELHO1;

            when S_VERMELHO1 =>
                if ped_request = '1' then
                    next_state <= S_VERMELHO2;  -- se pedestre pediu
                else
                    next_state <= S_VERDE;      -- ciclo normal
                end if;

            when S_VERMELHO2 =>
                next_state <= S_VERDE;          -- final do ciclo com pedestre
        end case;
    end process;

    -- Saidas
    process(state)
    begin
        verde    <= '0';
        amarelo  <= '0';
        vermelho <= '0';

        case state is
            when S_VERDE =>
                verde <= '1';
            when S_AMARELO =>
                amarelo <= '1';
            when S_VERMELHO1 | S_VERMELHO2 =>
                vermelho <= '1';
        end case;
    end process;
end Behavioral;
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_semaforo.vhd)</summary>

```vhdl
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
```
</details>

---
