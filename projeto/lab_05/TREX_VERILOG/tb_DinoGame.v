// Simulacao opcional: iverilog -g2005-sv -s tb_DinoGame -o testbench.out
//                         DinoGame.v tb_DinoGame.v
//                         vvp testbench.out
`timescale 1ns/1ps
module tb_DinoGame;
    reg CLOCK_50 = 1'b0;
    reg [3:0] KEY = 4'b1111;
    reg frame_tick = 1'b0;
    wire [35:0] data;
    always #10 CLOCK_50 = ~CLOCK_50;

    DinoGame uut (.CLOCK_50(CLOCK_50), .KEY(KEY),
                  .frame_tick(frame_tick), .game_data(data));

    task frame;
    begin
        @(negedge CLOCK_50);
        frame_tick = 1'b1;
        @(negedge CLOCK_50);
        frame_tick = 1'b0;
        repeat (3) @(negedge CLOCK_50);
    end
    endtask

    task jump_click;
    begin
        KEY[0] = 1'b0;
        repeat (5) @(negedge CLOCK_50);
        KEY[0] = 1'b1;
        repeat (5) @(negedge CLOCK_50);
    end
    endtask

    integer k;
    initial begin
        repeat(5) @(negedge CLOCK_50);
        KEY[3] = 1'b0;
        repeat(4) @(negedge CLOCK_50);
        KEY[3] = 1'b1;
        repeat(5) @(negedge CLOCK_50);

        if (data[35:34] !== 2'd0) begin
            $display("ERRO: estado inicial"); $finish;
        end
        jump_click;
        frame;
        if (data[35:34] !== 2'd1) begin
            $display("ERRO: inicio de jogo"); $finish;
        end
        for (k=0;k<20;k=k+1) frame;
        if (data[13:2] == 0) begin
            $display("ERRO: pontuacao"); $finish;
        end
        jump_click;
        frame;
        if (data[33:26] == 0) begin
            $display("ERRO: salto"); $finish;
        end
        for (k=0;k<28;k=k+1) frame;
        if (data[33:26] != 0) begin
            $display("ERRO: aterrissagem"); $finish;
        end

        KEY[2] = 0;
        repeat(5) @(negedge CLOCK_50);
        KEY[2] = 1;
        repeat(5) @(negedge CLOCK_50);
        frame;
        if (data[35:34] !== 2'd0) begin
            $display("ERRO: botao de reinicio"); $finish;
        end

        jump_click;
        frame;
        for (k=0;k<170;k=k+1) frame;
        if (data[35:34] !== 2'd2) begin
            $display("ERRO: colisao com o cactus"); $finish;
        end
        $display("OK: inicio, score, salto, reinicio e colisao");
        $finish;
    end
endmodule
