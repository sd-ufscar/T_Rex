// Teste funcional da implementacao simplificada, sem placar ou pterodactilo.
`timescale 1ns/1ps
module tb_DinoGame;
    reg CLOCK_50 = 1'b0;
    reg [3:0] KEY = 4'b1111;
    reg frame_tick = 1'b0;
    wire [35:0] game_data;
    integer k;
    reg [7:0] peak;
    always #10 CLOCK_50 = ~CLOCK_50;
    DinoGame dut (.CLOCK_50(CLOCK_50),.KEY(KEY),
                  .frame_tick(frame_tick),.game_data(game_data));
    task frame;
        begin
            @(negedge CLOCK_50); frame_tick = 1'b1;
            @(negedge CLOCK_50); frame_tick = 1'b0;
            repeat(3) @(negedge CLOCK_50);
        end
    endtask
    task key0_click;
        begin
            KEY[0] = 0; repeat(5) @(negedge CLOCK_50);
            KEY[0] = 1; repeat(5) @(negedge CLOCK_50);
        end
    endtask
    task key2_click;
        begin
            KEY[2] = 0; repeat(5) @(negedge CLOCK_50);
            KEY[2] = 1; repeat(5) @(negedge CLOCK_50);
        end
    endtask
    initial begin
        repeat(4) @(negedge CLOCK_50);
        KEY[3] = 0; repeat(4) @(negedge CLOCK_50);
        KEY[3] = 1; repeat(5) @(negedge CLOCK_50);
        if (game_data[35:34] !== 2'd0) begin
            $display("ERRO: estado READY"); $finish(1);
        end
        key0_click; frame;
        if (game_data[35:34] !== 2'd1) begin
            $display("ERRO: inicio por KEY0"); $finish(1);
        end
        if (game_data[14:0] !== 15'd0) begin
            $display("ERRO: campos reservados"); $finish(1);
        end
        key0_click; frame;
        if (game_data[33:26] == 0) begin
            $display("ERRO: salto nao iniciado"); $finish(1);
        end
        peak = game_data[33:26];
        for(k=0;k<30;k=k+1) begin
            frame;
            if (game_data[33:26] > peak) peak = game_data[33:26];
        end
        if(peak !== 8'd78 || game_data[33:26] !== 8'd0) begin
            $display("ERRO: subida/descida linear, pico=%d final=%d",peak,game_data[33:26]);
            $finish(1);
        end
        key2_click; frame;
        if(game_data[35:34] !== 2'd0) begin
            $display("ERRO: KEY2 nao retornou a READY"); $finish(1);
        end
        key0_click; frame;
        for(k=0;k<175;k=k+1) frame;
        if(game_data[35:34] !== 2'd2) begin
            $display("ERRO: colisao com cacto"); $finish(1);
        end
        $display("OK: estados, salto linear, retorno e colisao com cacto");
        $finish;
    end
endmodule
