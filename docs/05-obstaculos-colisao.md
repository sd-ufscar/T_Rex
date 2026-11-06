# 05 — Obstáculos, geração pseudoaleatória e colisões

## Um obstáculo de cada vez

O controlador guarda a coordenada `obstacle_x` em dez bits. O valor **700** indica ausência de obstáculo na tela. Quando um obstáculo é lançado, a posição passa a **639** e diminui a cada quadro de acordo com `speed`. O projeto não movimenta uma lista simultânea de obstáculos.

A variável `bird` seleciona um de dois desenhos: **0=cacto**, **1=pterodáctilo**. Na primeira corrida o obstáculo inicial é um cacto; após a liberação de outros obstáculos, a seleção pode utilizar um bit pseudoaleatório.

## Pseudoaleatoriedade e intervalo

O código usa um registrador `random_bits` de oito bits, inicializado com `8'hA5`. A atualização desloca seus bits e calcula o novo bit a partir de XOR dos bits 7, 5, 4 e 3. Trata-se de um LFSR, portanto a sequência é determinística a partir da semente, não de aleatoriedade física.

O tipo pterodáctilo só pode ser selecionado após `score >= 12'h010` e quando `random_bits[0]` vale 1. O intervalo de espera é calculado a partir de **25 + random_bits[5:0]** quadros. A semente é reinicializada por KEY3.

## Aproximação das colisões

A detecção é por regiões e limites, não por comparação exaustiva dos pixels do sprite:

    near_cactus = (obstacle_x < 109) &&
                  (obstacle_x + 22 > 76);
    near_bird   = (obstacle_x < 125) &&
                  (obstacle_x + 42 > 76);
    collision = (obstacle_x < 640) &&
                ((!bird && near_cactus && jump_y < 42) ||
                 ( bird && near_bird && !ducking && jump_y < 45));

O cacto exige altura suficiente para evitar a colisão. Para o pterodáctilo, o personagem pode se proteger agachando no chão ou alcançando altura suficiente. Quando a condição de colisão é detectada, `state` recebe OVER e a evolução normal do jogo é interrompida.

## Considerações

A mudança de obstáculo, a alteração da velocidade e a avaliação de colisão ocorrem na atualização de quadro. Esse arranjo tem resolução temporal discreta; os limites do teste são aproximados e foram escolhidos para o estilo visual simplificado.

---
[Anterior](04-dino-game.md) · [Índice](../README.md#guia-completo) · [Próximo: desenho](06-dino-draw.md)