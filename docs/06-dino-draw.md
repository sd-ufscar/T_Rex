# 06 — Desenho gráfico e interface VGA

O arquivo [`DinoDraw.v`](../projeto/DinoDraw.v) calcula as cores diretamente por coordenada, sem armazenar um quadro completo de vídeo. A função auxiliar `box` testa se um pixel pertence a uma região retangular.

## Elementos da cena

| Elemento | Representação |
|---|---|
| Dinossauro | Sprite fixo formado por retângulos, deslocado verticalmente por `jump_y` |
| Cacto | Regiões retangulares próximas à linha do solo, deslocadas por `obstacle_x` |
| Cenário | Nuvens e solo em posições definidas |
| Mensagem inicial | `PRESS KEY0` |
| Mensagem final | `GAME OVER` |

A fonte matricial de 5 × 7 é expandida para desenhar as mensagens. O sprite do personagem mantém uma única forma, independentemente do quadro.

## Conversão para cores

Os sinais `VGA_R`, `VGA_G` e `VGA_B` possuem quatro bits cada. Os canais recebem valores iguais, formando tons de cinza. Fora de `video_on`, os canais são zerados.

O projeto mantém a estética monocromática, com a cena calculada combinacionalmente a partir de `pixel_x`, `pixel_y` e `game_data`.

[Anterior](05-obstaculos-colisao.md) · [Índice](../README.md#tutorial-técnico) · [Quartus](07-quartus.md)
