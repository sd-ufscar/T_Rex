// Logica digital simplificada do T-Rex.
// Apenas cactos, sem agachar, sem animacao de passos e sem placar.
// Botao KEY0 inicia/pula; KEY2 reinicia; KEY3 reseta tudo.
module DinoGame (
    input wire CLOCK_50,
    input wire [3:0] KEY,
    input wire frame_tick,
    output wire [35:0] game_data
);
    localparam READY = 2'd0, RUN = 2'd1, OVER = 2'd2;

    reg [1:0] state;
    reg [7:0] jump_y;
    reg jumping_up;                 // 1 = subindo, 0 = descendo/no chao
    reg [9:0] obstacle_x;           // 700 = obstaculo fora da tela
    reg [8:0] accel_count;
    reg [3:0] speed;
    reg [6:0] cooldown;
    reg [7:0] random_bits;

    // Sincronizacao das entradas e retencao de cliques ate o frame seguinte.
    reg [1:0] jump_sync, restart_sync;
    reg jump_prev, restart_prev;
    reg jump_request, restart_request;

    // Colisao apenas com o cacto.
    wire near_cactus = (obstacle_x < 10'd109) &&
                       (obstacle_x + 10'd22 > 10'd76);
    wire collision = (obstacle_x < 10'd640) && near_cactus && (jump_y < 8'd42);

    // Mantem os 36 bits para compatibilidade direta com o diagrama .bdf.
    assign game_data = {state, jump_y, 1'b0, obstacle_x, 15'd0};

    always @(posedge CLOCK_50 or negedge KEY[3]) begin
        if (!KEY[3]) begin
            state <= READY;
            jump_y <= 8'd0;
            jumping_up <= 1'b0;
            obstacle_x <= 10'd700;
            accel_count <= 9'd0;
            speed <= 4'd5;
            cooldown <= 7'd35;
            random_bits <= 8'hA5;
            jump_sync <= 2'b11;
            restart_sync <= 2'b11;
            jump_prev <= 1'b1;
            restart_prev <= 1'b1;
            jump_request <= 1'b0;
            restart_request <= 1'b0;
        end else begin
            jump_sync <= {jump_sync[0], KEY[0]};
            restart_sync <= {restart_sync[0], KEY[2]};
            jump_prev <= jump_sync[1];
            restart_prev <= restart_sync[1];

            if (jump_prev && !jump_sync[1]) jump_request <= 1'b1;
            if (restart_prev && !restart_sync[1]) restart_request <= 1'b1;

            if (frame_tick) begin
                jump_request <= 1'b0;
                restart_request <= 1'b0;

                if (restart_request) begin
                    state <= READY;
                    jump_y <= 8'd0;
                    jumping_up <= 1'b0;
                    obstacle_x <= 10'd700;
                    speed <= 4'd5;
                    accel_count <= 9'd0;
                end else if (state != RUN) begin
                    if (jump_request) begin
                        state <= RUN;
                        jump_y <= 8'd0;
                        jumping_up <= 1'b0;
                        obstacle_x <= 10'd639;
                        accel_count <= 9'd0;
                        speed <= 4'd5;
                        cooldown <= 7'd35;
                    end
                end else begin
                    random_bits <= {random_bits[6:0],
                        random_bits[7] ^ random_bits[5] ^
                        random_bits[4] ^ random_bits[3]};

                    // Movimento linear simples: sobe ate 78 e depois desce ate 0.
                    if (jump_y == 8'd0 && !jumping_up) begin
                        if (jump_request) begin
                            jumping_up <= 1'b1;
                            jump_y <= 8'd6;
                        end
                    end else if (jumping_up) begin
                        if (jump_y >= 8'd78) begin
                            jumping_up <= 1'b0;
                            jump_y <= jump_y - 8'd6;
                        end else begin
                            jump_y <= jump_y + 8'd6;
                        end
                    end else begin
                        if (jump_y <= 8'd6) begin
                            jump_y <= 8'd0;
                        end else begin
                            jump_y <= jump_y - 8'd6;
                        end
                    end

                    if (accel_count == 9'd359) begin
                        accel_count <= 9'd0;
                        if (speed < 4'd11) speed <= speed + 4'd1;
                    end else begin
                        accel_count <= accel_count + 9'd1;
                    end

                    if (obstacle_x == 10'd700) begin
                        if (cooldown != 7'd0) begin
                            cooldown <= cooldown - 7'd1;
                        end else begin
                            obstacle_x <= 10'd639;
                            cooldown <= 7'd25 + {1'b0, random_bits[5:0]};
                        end
                    end else if (obstacle_x <= {6'b0, speed}) begin
                        obstacle_x <= 10'd700;
                    end else begin
                        obstacle_x <= obstacle_x - {6'b0, speed};
                    end

                    if (collision) state <= OVER;
                end
            end
        end
    end
endmodule