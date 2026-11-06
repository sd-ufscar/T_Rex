# T-Rex Runner - DE1 classica / Verilog / esquema Quartus

Esta versao substitui o projeto anterior em VHDL. Foi feita seguindo o
**formato do exemplo `jogoVelha.7z`**: arquivos Verilog (`.v`), simbolos (`.bsf`),
uma folha grafica (`Block1.bdf`) que e o **top-level** e atribuicoes (`.qsf`).

**Placa:** Terasic DE1 classica, Cyclone II `EP2C20F484C7`.
**Video:** VGA `640x480`, aproximadamente `59,52 Hz`, RGB com 4 bits por cor.
**Dependencias:** nenhuma biblioteca adicional no codigo Verilog. Nao usa
`include`, `import`, IP de PLL nem processador embarcado.

## 1. O que foi mantido e o que foi simplificado

- O jogo avanca automaticamente e possui salto, agachamento e colisao.
- Obstaculos: **cactus** (deve saltar) e **pterodactilo** (pode agachar).
- Pontuacao de 000 a 999, no canto superior direito do VGA.
- Jogo com tres estados: aguardar, jogar e game over.
- Velocidade aumenta aos poucos. Tipo e intervalo do obstaculo usam LFSR.
- Dinossauro e passaros com animacao basica; cenario monocromatico.

Para facilitar o entendimento em Sistemas Digitais, ha **um obstaculo de cada
vez**. Retirei recordes, efeitos especiais e varios objetos simultaneos da
versao anterior. Os sprites sao aproximacoes em retangulos, nao copias exatas.

## 2. Controles

| Entrada da DE1 | Acao |
| --- | --- |
| `KEY0` | Comecar, pular ou iniciar outra partida apos perder |
| `KEY1` | Agachar enquanto segura o botao |
| `KEY2` | Voltar para tela inicial (zera pontos) |
| `KEY3` | Reset geral da FPGA |

Na DE1, os botoes KEY sao **ativos em 0**.

## 3. Os quatro modulos do diagrama

| Modulo | Arquivo | Funcao |
| --- | --- | --- |
| `video_PLL` | `video_PLL.v` | Gera `pixel_enable`, um pulso a cada 2 ciclos de 50 MHz |
| `VGA_SYNC` | `VGA_SYNC.v` | Conta x/y e produz `video_on`, HSync, VSync e `frame_tick` |
| `DinoGame` | `DinoGame.v` | Estados, botoes, salto, obstaculo, pontos e colisao |
| `DinoDraw` | `DinoDraw.v` | Converte posicoes e estado em RGB para o monitor |

Cada modulo tem seu **simbolo `.bsf`**. O arquivo `Block1.bdf` e a folha
esquematica com os quatro blocos, suas entradas, saidas e conexoes.
`DIAGRAMA_MODULOS.svg` e `DIAGRAMA_MODULOS.png` trazem uma visao simplificada
de consulta rapida, mesmo sem abrir o Quartus.

### Como os dois PDFs da aula foram aproveitados

1. **`Video_PLL.vhd`**: no material, ele dividia o clock da DE1 de 50 para
   25 MHz usando a biblioteca proprietaria `altera_mf`. Aqui foi convertido
   em `video_PLL.v`: o sinal `pixel_enable` alterna a cada ciclo de 50 MHz,
   e o sincronizador avanca somente quando ele vale 1. Assim obtemos **a
   mesma cadencia de 25 milhoes de pixels/s**, sem importar biblioteca nem
   criar um clock derivado dentro da malha logica. **Importante:** apesar do
   nome de compatibilidade, esta implementacao **nao e uma PLL fisica**.
2. **`VGA_SYNC.vhd`**: o esquema de 640x480, HSync/VSync e janela ativa foi
   portado para `VGA_SYNC.v`. As contagens foram corrigidas para `0..799`
   horizontal e `0..524` vertical, evitando ciclos extras do codigo original.

### Temporizacao

| Componente | Visivel | Front porch | Pulso sync | Back porch | Total |
| --- | ---: | ---: | ---: | ---: | ---: |
| Horizontal (pixels) | 640 | 16 | 96 | 48 | 800 |
| Vertical (linhas) | 480 | 10 | 2 | 33 | 525 |

`50 MHz / 2 / (800 * 525) = 59,52 Hz`. O VGA aceita sincronismos negativos.

## 4. Passo a passo no Quartus II

1. Extraia **toda a pasta** `TREX_VERILOG` do ZIP.
2. Instale/abra uma versao do **Quartus II com suporte a Cyclone II**;
   por exemplo, o Quartus II 13.0 SP1. Quartus Prime mais recente pode
   nao listar `EP2C20F484C7`.
3. Selecione **File > Open Project** e abra `TREX_VERILOG.qpf`.
4. Em **Assignments > Device**, confira `Cyclone II / EP2C20F484C7`.
5. Em **Assignments > Settings > General**, confira **Top-level entity:
   `Block1`**. Ele e um esquema e nao precisa de um `top.v` separado.
6. Abra `Block1.bdf` em **File > Open**. Verifique que estao visiveis os
   quatro blocos `video_PLL`, `VGA_SYNC`, `DinoGame`, `DinoDraw`.
7. Em **Assignments > Settings > Files**, confira os arquivos:
   `Block1.bdf`, `video_PLL.v`, `VGA_SYNC.v`, `DinoGame.v`, `DinoDraw.v`.
   O arquivo `tb_DinoGame.v` e apenas para teste e nao deve ser sintetizado.
8. Em **Assignments > Pin Planner**, confira `CLOCK_50`, KEY0..3,
   VGA_R/G/B0..3, VGA_HS e VGA_VS. Todos ja estao no `.qsf`.
9. Clique em **Processing > Start Compilation**.
10. Ao terminar sem erros, encontre `output_files/TREX_VERILOG.sof`.
    Confira o **Timing Analyzer**, especialmente a restricao de 50 MHz.

### Se o Quartus acusar erro interno do analisador grafico

Foi corrigida a propriedade **Default Value = VCC** nos pinos de entrada de
`Block1.bdf`, exigida pelo Quartus II 13.0. Se sua instalacao ainda apresentar
um erro interno ao processar o `.bdf`, abra a revisao alternativa
**`TREX_HDL.qpf`** em vez de `TREX_VERILOG.qpf`. Essa revisao sintetiza a mesma
logica com `TREX_TOP.v` como top-level e nao passa pelo analisador do `.bdf`.
O esquematico permanece no pacote para estudo/apresentacao.

Na revisao alternativa, o resultado fica em `output_files/TREX_HDL.sof`.

### Gravacao JTAG

11. Conecte o monitor no conector **VGA** da DE1 e o USB-Blaster ao PC.
12. Com a placa ligada, coloque **RUN/PROG em RUN**.
13. Abra **Tools > Programmer**, hardware **USB-Blaster**, modo **JTAG**.
14. Clique em **Add File**, escolha `output_files/TREX_VERILOG.sof`
    (ou `output_files/TREX_HDL.sof` se compilou a revisao alternativa).
15. Marque **Program/Configure** e clique **Start**.
16. Quando chegar a 100%, pressione brevemente KEY3, solte e depois KEY0.

### Testes na placa

1. A tela inicial exibe `PRESS KEY0` sobre o dinossauro.
2. KEY0 inicia a corrida; o primeiro obstaculo aparece pela direita.
3. KEY0 enquanto joga provoca um salto.
4. Quando aparecer um pterodactilo, segure KEY1 para abaixar.
5. Ao colidir, o movimento congela e aparece `GAME OVER`.
6. KEY0 inicia uma nova tentativa; KEY2 volta ao inicio; KEY3 reseta.

## 5. Simulacao opcional (sem FPGA)

Se tiver Icarus Verilog:

```bash
iverilog -g2005-sv -s tb_DinoGame -o testbench.out DinoGame.v tb_DinoGame.v
vvp testbench.out
```

O teste verifica inicio, pontuacao, salto, pouso, reinicio e colisao.
Nao e preciso usar bibliotecas extras para **sintetizar** o projeto.

## 6. Resumo de pinos

| Porta | Pino FPGA |
| --- | --- |
| CLOCK_50 | L1 |
| KEY[0..3] | R22, R21, T22, T21 |
| VGA_R[0..3] | D9, C9, A7, B7 |
| VGA_G[0..3] | B8, C10, B9, A8 |
| VGA_B[0..3] | A9, D11, A10, B10 |
| VGA_HS / VGA_VS | A11 / B11 |

Referencias: arquivo de exemplo `jogoVelha.7z`, os dois PDFs fornecidos pela
disciplina, [manual DE1](https://www.terasic.com.tw/attachment/archive/83/DE1_UserManual_v1018.pdf)
e [regras do T-Rex](https://dinorunner.com/pt/).

## 7. Limites de validacao

O codigo Verilog foi revisado estruturalmente e os nomes de pinos/conexoes
foram preparados para o projeto Quartus. **O `.sof` nao e fornecido**:
depende da compilacao com suporte a Cyclone II. Sem Quartus ou placa fisica
disponiveis neste ambiente, ainda nao posso afirmar que o Fitter ou o jogo
no monitor passaram no teste de laboratorio. Caso o Quartus mostre algum
erro, compartilhe a mensagem completa para que possamos ajustar o projeto.
