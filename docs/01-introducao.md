# 01 — Introdução e fundamentos

## Objetivo

O experimento implementa um jogo de corrida e desvio de obstáculos inteiramente em lógica digital, utilizando Verilog HDL e uma FPGA da placa Terasic DE1. O desenho é transmitido em VGA e a interação ocorre pelos quatro botões físicos.

## Plataforma

| Recurso | Valor verificado |
|---|---|
| Placa | Terasic DE1 clássica |
| FPGA | Cyclone II `EP2C20F484C7` |
| Clock principal | `CLOCK_50`, 50 MHz |
| IDE de referência | Quartus II 13.0 SP1 (13.0.1 Build 232) |
| Integração | `Block1.bdf` ou `TREX_TOP.v` na revisão alternativa |
| Saídas | `VGA_R/G/B[3:0]`, `VGA_HS`, `VGA_VS` |

## Conceitos aplicados

Os registradores conservam o estado do jogo entre atualizações: altura do salto, velocidade, posição e tipo do obstáculo, pontuação, ritmo de animação e modo de operação. Circuitos combinacionais comparam posições e produzem pixels. A temporização de vídeo ocorre em um ritmo distinto da atualização da partida.

O sistema não utiliza processador embarcado, software em tempo de execução, armazenamento de quadro completo ou ROM de sprites. O código gera os elementos por funções geométricas.

## Arquivos essenciais

Os fontes estão em [`projeto/lab_05/TREX_VERILOG/`](../projeto/lab_05/TREX_VERILOG/). O [diagrama de integração](../projeto/lab_05/diagrama_esquematico.png), o [teste funcional](../projeto/lab_05/TREX_VERILOG/tb_DinoGame.v) e os relatórios originais complementam o estudo.

---
[Índice](../README.md#guia-completo) · [Próximo: arquitetura](02-arquitetura.md)