// Logica digital do T-Rex: sem processador, IP externo ou biblioteca.
// Um unico obstaculo de cada vez: cactus ou pterodactilo.
// Botao KEY0 inicia/pula; KEY1 agacha; KEY2 reinicia; KEY3 reseta tudo.
module DinoGame (
    input wire CLOCK_50,
    input wire [3:0] KEY,
    input wire frame_tick,
    output wire [35:0] game_data
);
    localparam READY = 2'd0, RUN = 2'd1, OVER = 2'd2;

    reg [1:0] state;
    reg [7:0] jump_y;
    reg signed [7:0] jump_v;
    wire signed [9:0] predicted_y = $signed({2'b00, jump_y}) +
                                    $signed(jump_v);
    reg [9:0] obstacle_x;           // 700 = obstaculo fora da tela
    reg bird;                       // 0 = cactus, 1 = pterodactilo
    reg [11:0] score;               // BCD, 000..999
    reg anim;
    reg [2:0] anim_count;
    reg [2:0] score_count;
    reg [8:0] accel_count;
    reg [3:0] speed;
    reg [6:0] cooldown;
    reg [7:0] random_bits;

    // Sincronizacao das entradas e retencao de cliques ate o frame seguinte.
    reg [1:0] jump_sync, restart_sync, duck_sync;
    reg jump_prev, restart_prev;
    reg jump_request, restart_request;

    wire ducking = (!duck_sync[1]) && (jump_y == 8'd0);
    wire near_cactus = (obstacle_x < 10'd109) &&
                       (obstacle_x + 10'd22 > 10'd76);
    wire near_bird = (obstacle_x < 10'd125) &&
                     (obstacle_x + 10'd42 > 10'd76);
    wire collision = (obstacle_x < 10'd640) &&
             ((!bird && near_cactus && jump_y < 8'd42) ||
              ( bird && near_bird && !ducking && jump_y < 8'd45));

    // Compacta os sinais para deixar o diagrama .bdf mais legivel.
    assign game_data = {state, jump_y, ducking, obstacle_x, bird, score,
                        anim, 1'b0};

    function [11:0] score_plus_one;
        input [11:0] current;
        reg [11:0] updated;
        begin
            updated = current;
            if (current[3:0] != 4'd9) updated[3:0] = current[3:0] + 4'd1;
            else begin
                updated[3:0] = 4'd0;
                if (current[7:4] != 4'd9) updated[7:4] = current[7:4] + 4'd1;
                else begin
                    updated[7:4] = 4'd0;
                    if (current[11:8] != 4'd9) updated[11:8] = current[11:8] + 4'd1;
                    else updated[11:8] = 4'd0;
                end
            end
            score_plus_one = updated;
        end
    endfunction

    always @(posedge CLOCK_50 or negedge KEY[3]) begin
        if (!KEY[3]) begin
            state <= READY;
            jump_y <= 0;
            jump_v <= 0;
            obstacle_x <= 10'd700;
            bird <= 0;
            score <= 0;
            anim <= 0;
            anim_count <= 0;
            score_count <= 0;
            accel_count <= 0;
            speed <= 4'd5;
            cooldown <= 7'd35;
            random_bits <= 8'hA5;
            jump_sync <= 2'b11;
            restart_sync <= 2'b11;
            duck_sync <= 2'b11;
            jump_prev <= 1'b1;
            restart_prev <= 1'b1;
            jump_request <= 1'b0;
            restart_request <= 1'b0;
        end else begin
            jump_sync <= {jump_sync[0], KEY[0]};
            restart_sync <= {restart_sync[0], KEY[2]};
            duck_sync <= {duck_sync[0], KEY[1]};
            jump_prev <= jump_sync[1];
            restart_prev <= restart_sync[1];
            if (jump_prev && !jump_sync[1]) jump_request <= 1'b1;
            if (restart_prev && !restart_sync[1]) restart_request <= 1'b1;

            if (frame_tick) begin
                jump_request <= 1'b0;
                restart_request <= 1'b0;
                if (restart_request) begin
                    state <= READY;
                    jump_y <= 0;
                    jump_v <= 0;
                    obstacle_x <= 10'd700;
                    score <= 0;
                    speed <= 4'd5;
                    accel_count <= 0;
                end else if (state != RUN) begin
                    if (jump_request) begin
                        state <= RUN;
                        jump_y <= 0;
                        jump_v <= 0;
                        obstacle_x <= 10'd639;
                        bird <= 0;
                        score <= 0;
                        score_count <= 0;
                        accel_count <= 0;
                        speed <= 4'd5;
                        cooldown <= 7'd35;
                    end
                end else begin
                    random_bits <= {random_bits[6:0],
                        random_bits[7] ^ random_bits[5] ^
                        random_bits[4] ^ random_bits[3]};

                    // Movimento parabolico: velocidade diminui pela gravidade.
                    if (jump_y == 0 && jump_request) begin
                        jump_y <= 8'd12;
                        jump_v <= 8'sd11;
                    end else if (jump_y != 0) begin
                        if (predicted_y <= 0) begin
                            jump_y <= 0;
                            jump_v <= 0;
                        end else begin
                            jump_y <= predicted_y[7:0];
                            jump_v <= jump_v - 8'sd1;
                        end
                    end

                    if (anim_count == 3'd5) begin
                        anim_count <= 0;
                        anim <= !anim;
                    end else anim_count <= anim_count + 3'd1;

                    if (score_count == 3'd5) begin
                        score_count <= 0;
                        score <= score_plus_one(score);
                    end else score_count <= score_count + 3'd1;

                    if (accel_count == 9'd359) begin
                        accel_count <= 0;
                        if (speed < 4'd11) speed <= speed + 4'd1;
                    end else accel_count <= accel_count + 9'd1;

                    if (obstacle_x == 10'd700) begin
                        if (cooldown != 0) cooldown <= cooldown - 7'd1;
                        else begin
                            obstacle_x <= 10'd639;
                            bird <= (score >= 12'h010) && random_bits[0];
                            cooldown <= 7'd25 + {1'b0,random_bits[5:0]};
                        end
                    end else if (obstacle_x <= {6'b0,speed}) begin
                        obstacle_x <= 10'd700;
                    end else obstacle_x <= obstacle_x - {6'b0,speed};

                    if (collision) state <= OVER;
                end
            end
        end
    end
endmodule
