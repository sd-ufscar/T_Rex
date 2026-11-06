# 08 — Resultados e verificações

## Registros visuais

As fotografias apresentadas no relatório acadêmico documentam dois estados da interface VGA. A tela inicial contém dinossauro, nuvens, solo, `PRESS KEY0` e pontuação `000`. A tela de encerramento contém `GAME OVER` e o marcador `515`. O código associa essas mensagens aos estados READY e OVER. O valor 515 é um exemplo observado, e não a pontuação máxima, que utiliza três dígitos BCD.

O repositório possui o [diagrama de módulos](../projeto/lab_05/TREX_VERILOG/DIAGRAMA_MODULOS.png) e o [esquemático original](../projeto/lab_05/diagrama_esquematico.png). As duas fotografias do monitor foram fornecidas separadamente para o relatório; não são inferidas dos arquivos binários do projeto.

## Teste funcional automatizado

O arquivo [`tb_DinoGame.v`](../projeto/lab_05/TREX_VERILOG/tb_DinoGame.v) verifica estado inicial, início por KEY0, avanço da pontuação, salto, pouso, retorno a READY por KEY2 e colisão após a execução de quadros simulados. O [workflow de validação](../.github/workflows/validar-verilog.yml) usa Icarus Verilog para analisar `TREX_TOP` e executar o testbench.

Em **6 de novembro de 2026**, a execução do workflow terminou com sucesso, incluindo os passos de compilação do HDL e do testbench. [Ver histórico dos testes](https://github.com/sd-ufscar/T_Rex/actions). Isso não demonstra por si só toda a renderização VGA, o desempenho após roteamento nem os contatos físicos dos botões.

## Relatórios históricos do Quartus

Os arquivos originais indicam uma compilação da revisão TREX_VERILOG realizada em **27 de outubro de 2026**, no Quartus II 13.0 SP1, dispositivo `EP2C20F484C7`.

| Indicador no relatório original do Fitter | Valor |
|---|---:|
| Situação | Successful |
| Elementos lógicos | 1.023 / 18.752 (5%) |
| Registradores | 107 |
| Pinos | 19 |
| Bits de memória dedicada | 0 |
| PLLs físicas | 0 |

O resumo do TimeQuest apresenta `slack` de setup **+12,072 ns** no modelo lento para `CLOCK_50`, de hold **+0,445 ns** e de largura mínima de pulso **+8,889 ns**. São resultados históricos desta revisão, não produzidos pela publicação no GitHub.

## Limites

Não foram realizadas aqui nova compilação com Quartus, gravação JTAG, medida de frequência no osciloscópio nem verificação física de cada comando. As duas fotografias não mostram separadamente a colisão, o voo do pterodáctilo ou os estados intermediários.

---
[Anterior](07-quartus.md) · [Índice](../README.md#guia-completo) · [Próximo: validação](09-validacao.md)