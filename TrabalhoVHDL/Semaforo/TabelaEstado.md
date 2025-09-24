| Estado Atual       | Condição       | Próximo Estado      | Saídas (V A R) |
|------------------|----------------|------------------|----------------|
| S0 (Verde)        | após 1 tempo    | S1 (Amarelo)      | 1 0 0          |
| S1 (Amarelo)      | após 1 tempo    | S2 (Vermelho)     | 0 1 0          |
| S2 (Vermelho)     | btn=0           | S0 (Verde)        | 0 0 1          |
| S2 (Vermelho)     | btn=1           | S3 (VermelhoX)    | 0 0 1          |
| S3 (VermelhoX)    | após 1 tempo    | S0 (Verde)        | 0 0 1          |
