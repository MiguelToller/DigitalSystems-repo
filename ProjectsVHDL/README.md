<div align="center">

# Meus Projetos de VHDL - Sistemas Digitais

</div>

Este repositório contém uma coleção de projetos básicos em VHDL desenvolvidos para a disciplina de Sistemas Digitais, com foco na implementação de Máquinas de Estados Finitos (FSMs). Cada projeto inclui o código-fonte do design, um testbench para simulação e os resultados da simulação.

## Projetos

1.  [Detector de Sequência "101"](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/ProjectsVHDL/Detector_101)
2.  [Semáforo com Temporizador](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/ProjectsVHDL/Semaforo)
3.  [Porta com Senha "1101"](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/ProjectsVHDL/PortaSenha)
4.  [Contador de 3 Bits via FSM](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/ProjectsVHDL/Contador3b)
5.  [Máquina de Venda Automática](https://github.com/MiguelToller/DigitalSystems-repo/tree/main/ProjectsVHDL/MaquinaVenda)

---

## 1. Detector de Sequência "101"

Este projeto implementa uma FSM do tipo Moore que detecta a sequência de bits `101` em uma entrada serial.

#### Resultados da Simulação

![Simulação do Detector 101](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/ProjectsVHDL/Detector_101/tb_1.png)  
*Figura 1: Simulação do detector '101' mostrando a saída ativada após a sequência correta.*

#### Código Fonte
<details>
<summary>Clique para ver o código do Design (detector_101.vhd)</summary>

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity detector_101 is
    Port (
        clk : in STD_LOGIC; -- Clock
        reset : in STD_LOGIC; -- Reset síncrono-ativo-alto
        entrada : in STD_LOGIC; -- Entrada serial de bits
        saida : out STD_LOGIC -- Saída = '1' quando "101" detectado
    );
end detector_101;

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
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_detector_101.vhd)</summary>

```vhdl
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
```
</details>

---

## 2. Semáforo com Temporizador

Uma FSM Moore que controla um semáforo de trânsito, ciclando entre os estados Verde, Amarelo e Vermelho com temporizadores.

#### Resultados da Simulação

![Simulação do Semáforo](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/ProjectsVHDL/Semaforo/tb_semaforo.png)
*Figura 2: Simulação do semáforo mostrando a transição das luzes ao longo de vários segundos.*

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
        verde    : out STD_LOGIC;
        amarelo  : out STD_LOGIC;
        vermelho : out STD_LOGIC
    );
end semaforo;

architecture moore of semaforo is

    -- Definição dos estados
    type state_type is (SVERDE, SAMARELO, SVERMELHO);
    signal estado, prox_estado : state_type;

begin

    -- Processo de transição de estado
    process(clk, reset)
    begin
        if reset = '1' then
            estado <= SVERDE;
        elsif rising_edge(clk) then
            estado <= prox_estado;
        end if;
    end process;

    -- Processo de lógica de saída e definição do próximo estado
    process(estado)
    begin
        -- Inicialização das saídas
        verde    <= '0';
        amarelo  <= '0';
        vermelho <= '0';

        case estado is
            when SVERDE =>
                verde       <= '1';
                prox_estado <= SAMARELO;

            when SAMARELO =>
                amarelo     <= '1';
                prox_estado <= SVERMELHO;

            when SVERMELHO =>
                vermelho    <= '1';
                prox_estado <= SVERDE;

            when others =>
                prox_estado <= SVERDE;
        end case;
    end process;

end moore;
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_semaforo.vhd)</summary>

```vhdl
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
```
</details>

---

## 3. Porta com Senha "1101"

Uma FSM Moore que simula uma fechadura eletrônica. A porta abre (`aberta` = '1') por um ciclo de clock quando a sequência correta `1101` é inserida.

#### Resultados da Simulação
![Simulação da Porta com Senha](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/ProjectsVHDL/PortaSenha/tb_semaforo.png)
*Figura 3: Simulação da porta mostrando a saída `aberta` sendo ativada após a senha correta.*

#### Código Fonte
<details>
<summary>Clique para ver o código do Design (porta.vhd)</summary>

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity porta_senha is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        entrada : in  STD_LOGIC;
        aberta  : out STD_LOGIC
    );
end porta_senha;

architecture moore of porta_senha is

    -- Definição dos estados
    type state_type is (S0, S1, S11, S110, S1101);
    signal estado, prox_estado : state_type;

begin

    -- Processo de transição de estados (sincronizado com clock)
    process(clk, reset)
    begin
        if reset = '1' then
            estado <= S0;
        elsif rising_edge(clk) then
            estado <= prox_estado;
        end if;
    end process;

    -- Lógica de saída e definição do próximo estado
    process(estado, entrada)
    begin
        -- Saída padrão: porta fechada
        aberta <= '0';

        case estado is

            when S0 =>
                if entrada = '1' then
                    prox_estado <= S1;
                else
                    prox_estado <= S0;
                end if;

            when S1 =>
                if entrada = '1' then
                    prox_estado <= S11;
                else
                    prox_estado <= S0;
                end if;

            when S11 =>
                if entrada = '0' then
                    prox_estado <= S110;
                else
                    prox_estado <= S11;
                end if;

            when S110 =>
                if entrada = '1' then
                    prox_estado <= S1101;
                else
                    prox_estado <= S0;
                end if;

            when S1101 =>
                aberta <= '1'; -- Porta abre!
                if entrada = '1' then
                    prox_estado <= S1;
                else
                    prox_estado <= S0;
                end if;

            when others =>
                prox_estado <= S0;

        end case;
    end process;

end moore;
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_porta.vhd)</summary>

```vhdl
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
```
</details>

---

## 4. Contador de 3 Bits via FSM

Um contador crescente de 3 bits (0 a 7) que retorna ao início, implementado de forma explícita com uma FSM de 8 estados.

#### Resultados da Simulação
![Simulação do Contador de 3 bits](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/ProjectsVHDL/Contador3b/tb_contador3b.png)
*Figura 4: Simulação do contador mostrando a saída `q` incrementando de "000" a "111" e retornando a "000".*

#### Código Fonte
<details>
<summary>Clique para ver o código do Design (contador.vhd)</summary>

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador is
    Port (
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        q : out STD_LOGIC_VECTOR(2 downto 0)
    );
end contador;

architecture moore of contador is

    -- Definição dos estados (8 estados para contagem de 0 a 7)
    type state_type is (
        S000, S001, S010, S011,
        S100, S101, S110, S111
    );
    
    signal estado, prox_estado : state_type;

begin

    -- Processo de transição de estados (sincronizado com clock)
    process(clk, reset)
    begin
        if reset = '1' then
            estado <= S000;
        elsif rising_edge(clk) then
            estado <= prox_estado;
        end if;
    end process;

    -- Processo de lógica de saída e definição do próximo estado
    process(estado)
    begin
        case estado is

            when S000 =>
                q <= "000";
                prox_estado <= S001;

            when S001 =>
                q <= "001";
                prox_estado <= S010;

            when S010 =>
                q <= "010";
                prox_estado <= S011;

            when S011 =>
                q <= "011";
                prox_estado <= S100;

            when S100 =>
                q <= "100";
                prox_estado <= S101;

            when S101 =>
                q <= "101";
                prox_estado <= S110;

            when S110 =>
                q <= "110";
                prox_estado <= S111;

            when S111 =>
                q <= "111";
                prox_estado <= S000;

            when others =>
                q <= "000";
                prox_estado <= S000;

        end case;
    end process;

end moore;
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_contador.vhd)</summary>

```vhdl
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
```
</details>

---

## 5. Máquina de Venda Automática

Uma FSM Moore que simula uma máquina de vendas. O produto custa 75 centavos e a máquina aceita moedas de 25 e 50 centavos, liberando o produto e o troco (se necessário).

#### Diagrama de Estados

```
        +-----+               moeda_5=1               +-----+               moeda_5=1               +-----+
        | S0  | -----------------------------------> | S5  | -----------------------------------> | S10 |
        +-----+                                     +-----+                                     +-----+
          |                                           ^                                           |
          |                                           |                                           |
          |                                           |                                           |
moeda_10=1|                                  moeda_10=1                                  moeda_10=1
          v                                           v                                           v
        +-----+               moeda_5=1               +-----+ <---------------------------+     +-----+
        | S10 | -----------------------------------> | S15 |                                |     | S15 |
        +-----+                                     +-----+                                |     +-----+
          |                                           |                                     ^       |
          |                                           |                                     |       |
          |                                           v                                     |       |
          +----------------------------- (produto liberado) -------------------------------+       

```

#### Resultados da Simulação
![Simulação da Máquina de Venda](https://github.com/MiguelToller/DigitalSystems-repo/blob/main/ProjectsVHDL/MaquinaVenda/tb_MaquinaVenda.png)  
*Figura 5: Simulação mostrando uma compra com pagamento exato e outra com troco.*

#### Código Fonte
<details>
<summary>Clique para ver o código do Design (maquina_venda.vhd)</summary>

```vhdl
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
```
</details>

<details>
<summary>Clique para ver o código do TestBench (tb_maquina_venda.vhd)</summary>

```vhdl
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
```
</details>
