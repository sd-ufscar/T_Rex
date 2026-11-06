# 09 — Inventário, integridade e limitações da validação

## Origem dos arquivos

O repositório foi inicialmente publicado com um único arquivo `lab_05.7z` (Git blob `6e480b441e1136dc2750413e4be722ef5699e09c`). Esse compactado permanece intacto na raiz. Os arquivos úteis foram extraídos no próprio repositório para [`projeto/lab_05/TREX_VERILOG/`](../projeto/lab_05/TREX_VERILOG/), respeitando as subpastas originais. O [inventário gerado pela extração](../INVENTARIO_EXTRACAO.md) registra caminhos, tamanhos e SHA-256 dos arquivos publicados.

Arquivos de compilação regeneráveis, caches e binários locais não foram expostos individualmente; continuam preservados no `lab_05.7z`. O conteúdo original de projeto não foi reescrito para elaborar a documentação.

## Dependências presentes

A revisão principal possui `.qpf`, `.qsf`, `.bdf`, `.sdc`, quatro módulos Verilog, símbolos `.bsf` e relatórios históricos. A revisão alternativa possui `TREX_TOP.v` e seus próprios QPF/QSF. O modelo de FPGA e a atribuição dos pinos aparecem em ambos os arquivos QSF.

## Testes realmente executados

| Verificação | Situação |
|---|---|
| Arquivo 7z original | Preservado no GitHub |
| Extração controlada das fontes | Concluída por GitHub Actions |
| Dependências essenciais | Presentes na estrutura extraída |
| Análise sintática/topo HDL com Icarus | **Aprovada**, execução de 06/11/2026 |
| Testbench `tb_DinoGame.v` | **Aprovado**, execução de 06/11/2026 |
| Quartus II / Fitter | Resultado histórico de 27/10/2026, não reexecutado |
| Simulação integral de todos os pixels VGA | Não executada |
| Programação da DE1 | Não repetida nesta auditoria |

O teste funcional apresentado verifica início, pontuação, salto, aterrissagem, reinício e colisão. Não cobre automaticamente todas as posições, velocidades e tipos de obstáculos. O resultado do workflow está em [Actions](https://github.com/sd-ufscar/T_Rex/actions).

## Distinções importantes

O nome `video_PLL` não implica uma PLL física; o módulo implementa uma habilitação de pixels. A existência de sincronizadores de entrada não implica que os contatos mecânicos estejam livres de repiques. O valor 515 na fotografia é uma observação de uma partida, não uma constante da lógica. Os relatórios do TimeQuest incluem restrições de 50 MHz, mas não constituem prova de conformidade de todas as condições de laboratório.

## Escopo das alterações

As alterações de organização e documentação ocorreram **somente em `sd-ufscar/T_Rex`**. O repositório `sd-ufscar/tic_tac_toe` foi consultado apenas como referência didática e não foi modificado.

---
[Anterior](08-resultados.md) · [Índice](../README.md#guia-completo)