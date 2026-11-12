# 05 — Obstáculos e colisão

O jogo apresenta **um cacto por vez**, representado por `obstacle_x`, de 10 bits. A posição inicial do movimento visível é 639. Quando `obstacle_x = 700`, o obstáculo está fora da região de vídeo.

A cada `frame_tick` em RUN, o cacto percorre a tela da direita para a esquerda. A velocidade inicial é 5 pixels por quadro; o contador `accel_count` permite aumentá-la progressivamente até o limite de 11, em intervalos de 360 quadros.

## Intervalo entre obstáculos

Um registrador de deslocamento pseudoaleatório de oito bits (LFSR) determina o intervalo antes do próximo aparecimento. A semente é `8'hA5`; a espera é calculada como `25 + random_bits[5:0]`, em quadros. O tipo de obstáculo não varia.

## Detecção de colisão

O código verifica a proximidade horizontal do cacto e a altura do personagem:

```verilog
wire near_cactus = (obstacle_x < 10'd109) &&
                   (obstacle_x + 10'd22 > 10'd76);
wire collision = (obstacle_x < 10'd640) &&
                 near_cactus && (jump_y < 8'd42);
```

A colisão ocorre quando as regiões horizontais se aproximam e o dinossauro está abaixo da altura de proteção. O teste utiliza limites geométricos simplificados, e não comparação individual de pixels do sprite.

[Anterior](04-dino-game.md) · [Índice](../README.md#tutorial-técnico) · [Desenho](06-dino-draw.md)
