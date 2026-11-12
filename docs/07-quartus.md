# 07 — Abrir e programar na DE1

## Arquivos

Na pasta [`projeto/`](../projeto/) estão o projeto [`TREX_VERILOG.qpf`](../projeto/TREX_VERILOG.qpf), a configuração [`TREX_VERILOG.qsf`](../projeto/TREX_VERILOG.qsf), o [esquemático `Block1.bdf`](../projeto/Block1.bdf), os módulos Verilog, o arquivo de temporização `.sdc` e os símbolos `.bsf`. A revisão alternativa `TREX_HDL.qpf` usa `TREX_TOP.v` como topo textual.

## Compilação

1. Utilizar **Quartus II 13.0 SP1**, com suporte a **Cyclone II EP2C20F484C7**.
2. Abrir `projeto/TREX_VERILOG.qpf` e conferir o topo `Block1`.
3. Verificar os sinais CLOCK_50, KEY[3:0] e VGA no Pin Planner.
4. Confirmar o [arquivo `TREX_VERILOG.sdc`](../projeto/TREX_VERILOG.sdc), que declara o clock de 50 MHz.
5. Executar **Processing → Start Compilation**, examinar avisos e verificar o Fitter e TimeQuest.
6. Conectar a placa ao USB-Blaster e ao monitor VGA. Em **Tools → Programmer**, usar modo JTAG e o [`.sof`](../projeto/TREX_VERILOG.sof) adequado.

O arquivo `.pof` está igualmente disponível para programação compatível com o dispositivo. A utilização de um binário de programação pressupõe conferência do hardware e da revisão do projeto.

## Pinos principais

| Porta | Pinos |
|---|---|
| CLOCK_50 | L1 |
| KEY[0..3] | R22, R21, T22, T21 |
| VGA_R[0..3] | D9, C9, A7, B7 |
| VGA_G[0..3] | B8, C10, B9, A8 |
| VGA_B[0..3] | A9, D11, A10, B10 |
| VGA_HS / VGA_VS | A11 / B11 |

## Verificar sem placa

```sh
cd projeto
iverilog -g2005-sv -Wall -s TREX_TOP -tnull TREX_TOP.v DinoGame.v DinoDraw.v VGA_SYNC.v video_PLL.v
iverilog -g2005-sv -Wall -s tb_DinoGame -o trex_tb DinoGame.v tb_DinoGame.v
vvp trex_tb
```

[Anterior](06-dino-draw.md) · [Índice](../README.md#tutorial-técnico) · [Resultados](08-resultados.md)
