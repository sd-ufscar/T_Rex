# 07 — Abrir, compilar e programar na DE1

## Instalação e projetos disponíveis

O projeto original utiliza **Quartus II 13.0 SP1**, com suporte a **Cyclone II EP2C20F484C7**. Não substitua o dispositivo por uma DE10-Standard: os chips e pinos são diferentes.

Há duas revisões: a principal [`TREX_VERILOG.qpf`](../projeto/lab_05/TREX_VERILOG/TREX_VERILOG.qpf) usa o esquemático [`Block1.bdf`](../projeto/lab_05/TREX_VERILOG/Block1.bdf); a revisão [`TREX_HDL.qpf`](../projeto/lab_05/TREX_VERILOG/TREX_HDL.qpf) usa [`TREX_TOP.v`](../projeto/lab_05/TREX_VERILOG/TREX_TOP.v) como topo equivalente.

## Procedimento recomendado

1. Clonar o repositório completo e abrir a pasta `projeto/lab_05/TREX_VERILOG`.
2. No Quartus II 13.0 SP1, usar **File → Open Project** e abrir `TREX_VERILOG.qpf`.
3. Conferir `EP2C20F484C7`, `TOP_LEVEL_ENTITY Block1`, os arquivos `DinoGame.v`, `DinoDraw.v`, `VGA_SYNC.v`, `video_PLL.v` e `Block1.bdf`.
4. Conferir o arquivo [`TREX_VERILOG.sdc`](../projeto/lab_05/TREX_VERILOG/TREX_VERILOG.sdc): `create_clock -name CLOCK_50 -period 20.000 [get_ports {CLOCK_50}]`.
5. Abrir **Assignments → Pin Planner** e verificar os pinos do clock, KEY e VGA.
6. Executar **Processing → Start Compilation**. Examinar erros, avisos e resultados do Fitter e TimeQuest.
7. Conectar a DE1 à energia, USB-Blaster e monitor VGA.
8. Abrir **Tools → Programmer**, selecionar o hardware **USB-Blaster**, o modo **JTAG** e o `.sof` recém-gerado.
9. Selecionar **Program/Configure** e iniciar a gravação. Após o término, utilizar KEY3 (reset) e KEY0 (início) conforme o teste.

Se a análise do BDF falhar por incompatibilidade do editor gráfico, abrir a revisão `TREX_HDL.qpf`. Ela utiliza um topo Verilog e mantém os módulos de funcionamento e as atribuições físicas equivalentes. O arquivo `.sof` resultante terá nome relacionado à revisão escolhida.

## Atribuição de sinais externos

| Sinal | Pino da Cyclone II |
|---|---|
| `CLOCK_50` | L1 |
| `KEY[0..3]` | R22, R21, T22, T21 |
| `VGA_R[0..3]` | D9, C9, A7, B7 |
| `VGA_G[0..3]` | B8, C10, B9, A8 |
| `VGA_B[0..3]` | A9, D11, A10, B10 |
| `VGA_HS` / `VGA_VS` | A11 / B11 |

Os sinais possuem atribuições `3.3-V LVTTL` no QSF original. Conferir as ligações físicas antes da programação.

## Teste sem FPGA

Em uma instalação com Icarus Verilog, dentro da pasta do projeto, utilizar:

    iverilog -g2005-sv -Wall -s TREX_TOP -tnull TREX_TOP.v DinoGame.v DinoDraw.v VGA_SYNC.v video_PLL.v
    iverilog -g2005-sv -Wall -s tb_DinoGame -o trex_tb DinoGame.v tb_DinoGame.v
    vvp trex_tb

Existe também um [workflow de validação](../.github/workflows/validar-verilog.yml) no GitHub Actions, limitado a testes de código. **Ele não substitui uma compilação no Quartus e não grava a FPGA.**

---
[Anterior](06-dino-draw.md) · [Índice](../README.md#guia-completo) · [Próximo: resultados](08-resultados.md)