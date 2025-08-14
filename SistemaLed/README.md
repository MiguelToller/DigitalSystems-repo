# SistemaLed

O objetivo é representar um circuito lógico de **3 entradas** utilizando botões no Arduino,  
onde o LED acende apenas quando **todos os botões** estão pressionados simultaneamente.

> Projeto acadêmico desenvolvido na **Universidade Franciscana (UFN)**, na disciplina de **Sistemas Digitais**.  

## Imagens do Projeto

<p align="center">
  <img src="https://github.com/MiguelToller/DigitalSystems-repo/blob/main/SistemaLed/Imagens/LedOff.jpg" alt="LED desligado" width="400"/>
  <img src="https://github.com/MiguelToller/DigitalSystems-repo/blob/main/SistemaLed/Imagens/LedOn.jpg" alt="LED ligado" width="400"/>
</p>

<p align="center">
  <em>À esquerda: LED desligado — À direita: LED ligado</em>
</p>

## Componentes Utilizados
- 1 Arduino
- 3 botões
- 1 LED
- 1 resistor (220 Ω para o LED)
- Jumpers e protoboard

## Funcionamento
- Cada botão representa uma entrada do circuito lógico.
- Todos os botões usam `INPUT_PULLUP` para dispensar resistores externos de pull-down.
- O LED acende **apenas** se **os três botões** estiverem pressionados.

## Código
O código configura os três botões como entradas com `INPUT_PULLUP` e o LED como saída.  
Se todos os botões estiverem pressionados (`LOW`), o LED é ligado.
