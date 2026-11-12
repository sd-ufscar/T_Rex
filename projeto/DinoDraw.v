// Desenha diretamente os pixels RGB em VGA (versao simplificada).
module DinoDraw (
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire video_on,
    input wire [35:0] game_data,
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B
);
    wire [1:0] state = game_data[35:34];
    wire [7:0] jump_y = game_data[33:26];
    wire [9:0] obstacle_x = game_data[24:15];

    function box;
        input integer x, y, left, top, width, height;
        begin
            box = (x >= left) && (x < left + width) &&
                  (y >= top) && (y < top + height);
        end
    endfunction

    // Dinossauro com pose fixa (sem agachar e sem alternar as pernas).
    function dino_pixel;
        input integer x, y, jump;
        integer dx, dy;
        reg body;
        begin
            dx = x - 70;
            dy = y - (341 - jump);
            body = box(dx,dy,13,19,20,15) || box(dx,dy,23,13,9,14) ||
                   box(dx,dy,27,2,19,17)  || box(dx,dy,30,17,16,5) ||
                   box(dx,dy,2,25,14,6)   || box(dx,dy,0,22,7,5)   ||
                   box(dx,dy,25,28,9,4)   || box(dx,dy,17,33,6,11) ||
                   box(dx,dy,29,33,5,7)   || box(dx,dy,29,40,9,4);
            dino_pixel = body && !box(dx,dy,38,7,3,3);
        end
    endfunction

    function cactus_pixel;
        input integer x, y, left;
        integer dx, up;
        begin
            dx = x - left;
            up = 385 - y;
            cactus_pixel = box(dx,up,8,0,9,42)  ||
                           box(dx,up,1,16,8,6)  || box(dx,up,1,22,5,12) ||
                           box(dx,up,16,17,6,6) || box(dx,up,18,23,4,12);
        end
    endfunction

    // Letras 5x7 apenas para as duas mensagens necessarias.
    function [34:0] font_bits;
        input [7:0] ch;
        begin
            case(ch)
                "0": font_bits = {5'b01110,5'b10001,5'b10011,5'b10101,5'b11001,5'b10001,5'b01110};
                "A": font_bits = {5'b01110,5'b10001,5'b10001,5'b11111,5'b10001,5'b10001,5'b10001};
                "E": font_bits = {5'b11111,5'b10000,5'b10000,5'b11110,5'b10000,5'b10000,5'b11111};
                "G": font_bits = {5'b01111,5'b10000,5'b10000,5'b10111,5'b10001,5'b10001,5'b01111};
                "K": font_bits = {5'b10001,5'b10010,5'b10100,5'b11000,5'b10100,5'b10010,5'b10001};
                "M": font_bits = {5'b10001,5'b11011,5'b10101,5'b10101,5'b10001,5'b10001,5'b10001};
                "O": font_bits = {5'b01110,5'b10001,5'b10001,5'b10001,5'b10001,5'b10001,5'b01110};
                "P": font_bits = {5'b11110,5'b10001,5'b10001,5'b11110,5'b10000,5'b10000,5'b10000};
                "R": font_bits = {5'b11110,5'b10001,5'b10001,5'b11110,5'b10100,5'b10010,5'b10001};
                "S": font_bits = {5'b01111,5'b10000,5'b10000,5'b01110,5'b00001,5'b00001,5'b11110};
                "V": font_bits = {5'b10001,5'b10001,5'b10001,5'b10001,5'b10001,5'b01010,5'b00100};
                "Y": font_bits = {5'b10001,5'b10001,5'b01010,5'b00100,5'b00100,5'b00100,5'b00100};
                default: font_bits = 35'd0;
            endcase
        end
    endfunction

    function [7:0] letter_at;
        input [1:0] mode;
        input integer index;
        begin
            letter_at = " ";
            if (mode == 2'd0) begin // PRESS KEY0
                case(index)
                    0:letter_at="P"; 1:letter_at="R"; 2:letter_at="E";
                    3:letter_at="S"; 4:letter_at="S"; 6:letter_at="K";
                    7:letter_at="E"; 8:letter_at="Y"; 9:letter_at="0";
                    default:letter_at=" ";
                endcase
            end else if (mode == 2'd2) begin // GAME OVER
                case(index)
                    0:letter_at="G"; 1:letter_at="A"; 2:letter_at="M";
                    3:letter_at="E"; 5:letter_at="O"; 6:letter_at="V";
                    7:letter_at="E"; 8:letter_at="R";
                    default:letter_at=" ";
                endcase
            end
        end
    endfunction

    function message_pixel;
        input [1:0] mode;
        input integer x, y;
        integer i, local_x, row, col;
        reg [34:0] bmp;
        begin
            message_pixel = 1'b0;
            if (mode != 2'd1 && y >= 205 && y < 219) begin
                row = (y - 205) / 2;
                for (i = 0; i < 10; i = i + 1) begin
                    local_x = x - 260 - i*12;
                    if (local_x >= 0 && local_x < 10) begin
                        col = local_x / 2;
                        bmp = font_bits(letter_at(mode,i));
                        if (bmp[34 - row*5 - col]) message_pixel = 1'b1;
                    end
                end
            end
        end
    endfunction

    reg dark_pixel;
    reg light_pixel;
    always @* begin
        dark_pixel = 1'b0;
        light_pixel = 1'b0;

        // Nuvens estaticas e chao.
        if (box(pixel_x,pixel_y,170,104,65,2) ||
            box(pixel_x,pixel_y,180,95,17,2)  ||
            box(pixel_x,pixel_y,200,90,17,2)  ||
            box(pixel_x,pixel_y,216,95,16,2)  ||
            box(pixel_x,pixel_y,420,135,70,2) ||
            box(pixel_x,pixel_y,433,123,21,2) ||
            box(pixel_x,pixel_y,455,117,17,2)) light_pixel = 1'b1;

        if (pixel_y == 10'd385 ||
            (pixel_y == 10'd389 && pixel_x[5:0] < 6'd12))
            dark_pixel = 1'b1;

        if (dino_pixel(pixel_x,pixel_y,jump_y))
            dark_pixel = 1'b1;

        if (obstacle_x < 10'd640 && cactus_pixel(pixel_x,pixel_y,obstacle_x))
            dark_pixel = 1'b1;

        if (message_pixel(state,pixel_x,pixel_y))
            dark_pixel = 1'b1;

        if (!video_on) begin
            VGA_R = 4'd0; VGA_G = 4'd0; VGA_B = 4'd0;
        end else if (dark_pixel) begin
            VGA_R = 4'h2; VGA_G = 4'h2; VGA_B = 4'h2;
        end else if (light_pixel) begin
            VGA_R = 4'hC; VGA_G = 4'hC; VGA_B = 4'hC;
        end else begin
            VGA_R = 4'hF; VGA_G = 4'hF; VGA_B = 4'hF;
        end
    end
endmodule