# 03 — Temporização de vídeo e VGA

## O módulo video_PLL não utiliza PLL física

Apesar do nome herdado da interface, [`video_PLL.v`](../projeto/lab_05/TREX_VERILOG/video_PLL.v) apenas inverte `pixel_enable` a cada borda de `CLOCK_50`. O sincronizador atualiza as coordenadas somente quando esse bit está ativo.

    always @(posedge CLOCK_50 or negedge KEY[3]) begin
        if (!KEY[3]) pixel_enable <= 1'b0;
        else         pixel_enable <= ~pixel_enable;
    end

Portanto, há um avanço de pixel a cada dois ciclos do clock de 50 MHz: **25 milhões de avanços por segundo**. A FPGA permanece em um domínio de clock; não é criado um segundo clock externo. A ausência de PLLs também aparece no relatório do Fitter.

## Coordenadas do quadro

O [`VGA_SYNC.v`](../projeto/lab_05/TREX_VERILOG/VGA_SYNC.v) conta `pixel_x` de **0 a 799** e `pixel_y` de **0 a 524**, reiniciando os contadores ao final da linha e do quadro. A janela visível utiliza `pixel_x < 640` e `pixel_y < 480`.

| Intervalo | Horizontal | Vertical |
|---|---:|---:|
| Ativo | 640 | 480 |
| Front porch | 16 | 10 |
| Pulso de sincronismo | 96 | 2 |
| Back porch | 48 | 33 |
| **Total** | **800** | **525** |

Os pulsos de sincronização são ativos em zero. `VGA_HS` fica baixo no intervalo horizontal **656–751** e `VGA_VS` no intervalo vertical **490–491**.

## Taxa nominal de atualização

    f_pixel = 50.000.000 / 2 = 25.000.000 Hz
    f_quadro = 25.000.000 / (800 × 525) ≈ 59,5238 Hz
    T_quadro = 1 / f_quadro ≈ 16,8 ms

O sinal `frame_tick` é verdadeiro quando `pixel_enable=1` e as coordenadas são `(0,0)`. Ele fornece um pulso de clock principal por quadro para o controlador do jogo. Os valores são deduzidos do HDL; não constituem medição no osciloscópio.

## Reset

`KEY3` em nível baixo reinicia as coordenadas e a habilitação de pixel. O sincronismo é produzido por lógica combinacional a partir dos contadores.

---
[Anterior](02-arquitetura.md) · [Índice](../README.md#guia-completo) · [Próximo: lógica do jogo](04-dino-game.md)