# 06 — Geração gráfica: DinoDraw

## Desenho diretamente por coordenadas

O arquivo [`DinoDraw.v`](../projeto/lab_05/TREX_VERILOG/DinoDraw.v) recebe coordenadas de 10 bits, `video_on` e o barramento `game_data[35:0]`. Sua lógica é **combinacional**, usando funções geométricas para decidir a cor de cada pixel, sem framebuffer e sem ROM de imagens.

A função `box(x,y,left,top,width,height)` testa se o pixel atual pertence a um retângulo. Sprites são formados pela união e subtração de retângulos, com algumas posições reservadas para os olhos.

## Elementos desenhados

| Elemento | Implementação |
|---|---|
| Dinossauro | `dino_pixel`, aproximadamente na posição horizontal 70; versões em pé, correndo/saltando ou agachado |
| Cacto | `cactus_pixel`, com posição horizontal variável e base próxima a `y=385` |
| Pterodáctilo | `bird_pixel`, região próxima de `y=333`, alternância de asas pelo bit `anim` |
| Solo | Linha em `y=385` e pequenos traços em `y=389` |
| Nuvens | Segmentos fixos próximos das regiões superiores do vídeo |
| Pontuação | Três dígitos desenhados por segmentos nas posições x=534, 562 e 590 |
| Mensagens | Fonte matricial 5 × 7, ampliada duas vezes, com caracteres para `PRESS KEY0` e `GAME OVER` |

## Cores e vídeo ativo

O circuito não usa uma paleta complexa. Quando `video_on` vale 1, as intensidades de cada canal RGB são iguais, gerando tons de cinza: fundo **`F,F,F`**, detalhes claros **`C,C,C`** e elementos escuros **`2,2,2`**. Fora da área de vídeo ativo, as três saídas são zero.

## Pontuação e mensagens

A pontuação é BCD e a função `seven_segments` converte cada dígito em sete traços geométricos no canto superior direito da imagem VGA. **Não são os displays de sete segmentos físicos da placa.**

A função `font_bits` armazena padrões de letras 5 × 7; `letter_at` escolhe a sequência de caracteres para os estados READY e OVER; e `message_pixel` determina quais pixels da mensagem devem ser escuros. Não há mensagem durante RUN.

## Relação com as fotografias

A tela inicial contém `PRESS KEY0` e `000`. A tela de encerramento apresenta `GAME OVER` e `515`. O código permite interpretar as mensagens como resultado dos estados e da função gráfica. As fotografias ilustram dois momentos específicos, não toda a animação.

---
[Anterior](05-obstaculos-colisao.md) · [Índice](../README.md#guia-completo) · [Próximo: Quartus](07-quartus.md)