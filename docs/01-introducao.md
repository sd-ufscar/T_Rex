# 01 — Introdução

O projeto implementa um jogo digital do tipo corrida infinita em FPGA, utilizando módulos Verilog combinados em uma folha esquemática do Quartus II. O personagem é representado em pixels, desloca-se verticalmente quando ocorre um salto e deve ultrapassar cactos que avançam da direita para a esquerda.

A plataforma é a **Terasic DE1 (Cyclone II EP2C20F484C7)**. A entrada CLOCK_50 de 50 MHz alimenta o processamento; uma habilitação determina o ritmo da varredura VGA. Os botões KEY0, KEY2 e KEY3 são utilizados para interação.

### Principais conceitos

A lógica sequencial registra estado, altura, direção de salto, posição e velocidade do obstáculo, intervalo de espera e semente pseudoaleatória. A lógica combinacional verifica a colisão e desenha a cena no monitor. Não existe framebuffer: a cor de cada pixel é calculada a partir de suas coordenadas.

Os arquivos estão diretamente na [pasta do projeto](../projeto/), com o [esquemático principal](../projeto/Block1.bdf), os quatro módulos Verilog e o teste funcional.

[Voltar ao índice](../README.md#tutorial-técnico) · [Arquitetura](02-arquitetura.md)
