# 09 — Organização e limites da validação

O projeto está publicado diretamente em [`projeto/`](../projeto/), com uma única árvore de arquivos. Não é necessário extrair um arquivo compactado para abrir o Quartus.

## Conferências previstas

- Identificar as fontes Verilog, o projeto QPF/QSF, o esquemático principal BDF e a restrição SDC.
- Compilar o topo alternativo `TREX_TOP` com Icarus Verilog.
- Executar [`tb_DinoGame.v`](../projeto/tb_DinoGame.v), verificando a lógica linear de salto e a colisão.
- Conferir os [relatórios do Quartus](../projeto/TREX_VERILOG.fit.summary) e o [resumo temporal](../projeto/TREX_VERILOG.sta.summary).
- Verificar, antes da programação física, a correspondência do dispositivo, dos pinos e do arquivo SOF.

## Limites

O workflow de simulação não realiza a síntese no Quartus. Os relatórios apresentados foram gerados no ambiente de projeto em 10/11/2026; a auditoria do repositório apenas confere a presença e as informações contidas nesses arquivos. Não foram realizados novos ensaios físicos da placa nem medições externas da temporização VGA nesta atualização.

Os recursos implementados são os descritos no [README](../README.md): corrida, salto linear, cacto móvel, mensagem de início e encerramento. A documentação não depende de arquivos históricos para explicar os comportamentos do circuito.

[Anterior](08-resultados.md) · [Índice](../README.md#tutorial-técnico)
