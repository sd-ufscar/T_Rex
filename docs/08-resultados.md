# 08 — Resultados e evidências técnicas

O pacote atualizado contém arquivos de programação e relatórios gerados pelo **Quartus II 13.0 SP1**, com compilação registrada em **10 de novembro de 2026** para a FPGA Cyclone II `EP2C20F484C7`.

| Indicador | Valor registrado |
|---|---:|
| Estado do Fitter | Successful |
| Elementos lógicos | 774 de 18.752 (4%) |
| Registradores totais | 77 |
| Pinos utilizados | 19 |
| Bits de memória dedicada | 0 |
| PLL físicas | 0 |
| Setup slack (modelo lento) | +11,655 ns |
| Hold slack (modelo lento) | +0,445 ns |

Fontes: [Fitter](../projeto/TREX_VERILOG.fit.summary), [TimeQuest](../projeto/TREX_VERILOG.sta.summary), [relatório completo do Fitter](../projeto/TREX_VERILOG.fit.rpt) e [relatório completo do TimeQuest](../projeto/TREX_VERILOG.sta.rpt).

## Simulação de controle

O [testbench atualizado](../projeto/tb_DinoGame.v) verifica transições READY/RUN/OVER, pico e retorno do salto linear, reinício por KEY2, integridade dos bits reservados do barramento e detecção de colisão com cacto. O [workflow](../.github/workflows/validar-verilog.yml) compila o topo HDL e executa esse teste com Icarus Verilog.

O sucesso desses testes é um resultado de simulação do controlador, distinto da compilação de FPGA. Não há neste repositório fotografias comprovadamente correspondentes ao resultado da implementação atual ou diagramas de ondas externos da nova versão.

[Anterior](07-quartus.md) · [Índice](../README.md#tutorial-técnico) · [Validação](09-validacao.md)
