# T-Rex em FPGA — projeto atual

Implementação didática de um jogo de corrida com salto e desvio de cactos, desenvolvida para a disciplina de **Sistemas Digitais — UFSCar (2026)**. O circuito é escrito em Verilog HDL, integrado no **Quartus II 13.0 SP1**, e utiliza a **Terasic DE1**, FPGA Cyclone II `EP2C20F484C7`, com monitor VGA.

## Características

| Item | Implementação |
|---|---|
| Cena | Dinossauro, nuvens, solo e cactos |
| Obstáculos | Um cacto móvel por vez |
| Salto | Movimento vertical linear, passos de 6 pixels por quadro até 78 e retorno |
| Estados | READY, RUN e OVER |
| Controles | KEY0 inicia/salta/reinicia partida; KEY2 retorna à tela inicial; KEY3 reinicializa |
| Vídeo | 640 × 480, varredura 800 × 525, habilitação de pixels a 25 MHz |
| Placa e ambiente | Terasic DE1 clássica; Quartus II 13.0 SP1 |
| Configuração | `projeto/TREX_VERILOG.qpf`, topo `Block1.bdf` |
| Programação | Arquivos `.sof` e `.pof` produzidos pela compilação de 10/11/2026 |

O pino **KEY1 não é utilizado pela lógica atual**. Não há marcador de pontuação na tela. A renderização utiliza retângulos em cores de cinza e uma fonte matricial para as mensagens `PRESS KEY0` e `GAME OVER`.

## Arquitetura

![Diagrama dos quatro módulos](projeto/DIAGRAMA_MODULOS.svg)

- **`video_PLL.v`**: alterna `pixel_enable` no domínio de 50 MHz; não emprega PLL física.
- **`VGA_SYNC.v`**: produz posição dos pixels, vídeo ativo, sincronismos VGA e `frame_tick`.
- **`DinoGame.v`**: controla estados, salto linear, movimento do cacto, aceleração, intervalo entre obstáculos e colisão.
- **`DinoDraw.v`**: calcula os pixels do personagem, do cacto, do solo, das nuvens e das mensagens.
- **`game_data[35:0]`**: comunica estado, altura do salto e posição do cacto; os demais bits estão reservados.

## Como executar

1. Clonar o repositório e abrir a pasta [`projeto/`](projeto/).
2. No **Quartus II 13.0 SP1**, abrir [`TREX_VERILOG.qpf`](projeto/TREX_VERILOG.qpf) e conferir o dispositivo Cyclone II `EP2C20F484C7`.
3. Abrir [`Block1.bdf`](projeto/Block1.bdf), revisar as conexões e o [arquivo QSF](projeto/TREX_VERILOG.qsf).
4. Compilar ou utilizar o [`.sof` do pacote](projeto/TREX_VERILOG.sof) quando adequado para a placa e configuração.
5. Gravar a FPGA no **Programmer**, modo JTAG, conectar o monitor VGA e utilizar os comandos da tabela.

| Botão | Ação |
|---|---|
| KEY0 | Iniciar, saltar durante RUN ou reiniciar após GAME OVER |
| KEY1 | Sem função nesta implementação |
| KEY2 | Voltar para READY |
| KEY3 | Reset geral, ativo em nível baixo |

## Tutorial técnico

| Capítulo | Tema |
|---|---|
| [01 — Introdução](docs/01-introducao.md) | Contexto e componentes |
| [02 — Arquitetura](docs/02-arquitetura.md) | Sinais e barramento de estado |
| [03 — VGA](docs/03-vga-temporizacao.md) | Clock, contadores e sincronismos |
| [04 — Lógica do jogo](docs/04-dino-game.md) | Máquina de estados e salto |
| [05 — Cactos e colisão](docs/05-obstaculos-colisao.md) | Movimento e verificação da colisão |
| [06 — Desenho gráfico](docs/06-dino-draw.md) | Pixels, cenário e mensagens |
| [07 — Quartus e gravação](docs/07-quartus.md) | Compilação e programação |
| [08 — Resultados](docs/08-resultados.md) | Fitter, TimeQuest e teste funcional |
| [09 — Validação](docs/09-validacao.md) | Conferências e limites |

## Verificação

O [testbench `tb_DinoGame.v`](projeto/tb_DinoGame.v) exercita início, salto, retorno à tela de espera e colisão com cacto. O [workflow de validação](.github/workflows/validar-verilog.yml) compila o topo Verilog e executa a simulação com Icarus. Os relatórios [Fitter](projeto/TREX_VERILOG.fit.summary) e [TimeQuest](projeto/TREX_VERILOG.sta.summary) são provenientes da compilação do Quartus de **10 de novembro de 2026**. A verificação em hardware não foi refeita nesta revisão documental.

As fontes, os esquemáticos, os relatórios e os arquivos de programação estão disponíveis individualmente na pasta [`projeto/`](projeto/), sem cópias de backup ou diretórios de cache.

**Disciplina:** Sistemas Digitais, UFSCar, Engenharia de Computação, Turma C (2026). **Professor:** Emerson Carlos Pedrino.
