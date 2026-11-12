# 03 — Temporização VGA

O módulo [`video_PLL.v`](../projeto/video_PLL.v) alterna `pixel_enable` em cada borda do relógio de 50 MHz. Apesar do nome, ele **não utiliza PLL física**; o sinal produz um avanço de pixel a cada dois ciclos do clock principal.

O [`VGA_SYNC.v`](../projeto/VGA_SYNC.v) implementa 800 contagens horizontais por 525 linhas e delimita uma janela visível de 640 × 480 pixels.

| Intervalo | Horizontal | Vertical |
|---|---:|---:|
| Vídeo ativo | 640 | 480 |
| Front porch | 16 | 10 |
| Pulso de sincronismo | 96 | 2 |
| Back porch | 48 | 33 |
| Total | 800 | 525 |

A frequência nominal de quadros é `25.000.000 / (800 × 525) ≈ 59,52 Hz`. Os pulsos `VGA_HS` e `VGA_VS` são ativos em nível baixo.

O evento `frame_tick` é emitido uma vez por quadro, permitindo atualizar a lógica de jogo sem alterar a posição do personagem a cada pixel. KEY3 reinicia os contadores e a habilitação de pixels.

[Anterior](02-arquitetura.md) · [Índice](../README.md#tutorial-técnico) · [Lógica do jogo](04-dino-game.md)
