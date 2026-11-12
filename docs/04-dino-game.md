# 04 — Controle e máquina de estados

A fonte [`DinoGame.v`](../projeto/DinoGame.v) usa três estados: READY (0), RUN (1) e OVER (2). O evento KEY0 inicia uma corrida, solicita um salto em RUN ou inicia outra partida depois do encerramento. KEY2 retorna à espera e KEY3 realiza reset geral, ativo em nível baixo.

## Salto linear

O controlador mantém `jump_y` (altura) e `jumping_up` (sentido do movimento). A cada `frame_tick`, enquanto houver salto:

1. No solo, um pedido de salto faz `jump_y = 6` e `jumping_up = 1`.
2. A altura cresce em passos de 6 até atingir 78 pixels.
3. A direção passa a ser descendente, com redução de 6 por quadro.
4. Em zero, o personagem pode receber um novo salto.

As expressões `jump_y + 8'd6` e `jump_y - 8'd6` são implementadas em registradores. O movimento é **linear por etapas**, com subida e descida, e não exige operações de ponto flutuante.

## Botões e atualização

KEY0 e KEY2 são sincronizados e seus eventos são mantidos até um `frame_tick`. Não existe filtragem de repique mecânico explícita no código. KEY1 não participa da lógica do jogo. O sinal `frame_tick` condiciona saltos, deslocamento de obstáculos e transições.

## Finalização

Quando `collision` é ativado durante RUN, o estado passa a OVER. O módulo de desenho usa esse estado para exibir `GAME OVER`. KEY0 inicia novamente; KEY2 retorna à mensagem inicial.

[Anterior](03-vga-temporizacao.md) · [Índice](../README.md#tutorial-técnico) · [Obstáculos](05-obstaculos-colisao.md)
