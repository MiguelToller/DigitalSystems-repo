| Estado Atual        | Condição                         | Próximo Estado      |
|-------------------|---------------------------------|------------------|
| S0 (Verde)         | btn=0 após 1 tempo               | S1 (Amarelo)      |
| S0 (Verde)         | btn=1 após 1 tempo               | S1 (Amarelo)      |
| S1 (Amarelo)       | sempre após 1 tempo              | S2 (Vermelho)     |
| S2 (Vermelho)      | ciclo normal, 1 tempo passou     | S0 (Verde)        |
| S2 (Vermelho)      | ciclo com botão, 1 tempo passou  | S3 (Vermelho Extra) |
| S3 (Vermelho Extra)| após 1 tempo                     | S0 (Verde)        |
