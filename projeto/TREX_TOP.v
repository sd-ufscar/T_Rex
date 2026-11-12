// Top-level Verilog equivalente as ligacoes da folha Block1.bdf.
// Alternativa de compilacao se o editor grafico da instalacao do Quartus
// nao conseguir analisar o arquivo .bdf.
module TREX_TOP (
    input wire CLOCK_50,
    input wire [3:0] KEY,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire VGA_HS,
    output wire VGA_VS
);
    wire pixel_enable;
    wire [9:0] pixel_x, pixel_y;
    wire video_on, frame_tick;
    wire [35:0] game_data;

    video_PLL u_clock (
        .CLOCK_50(CLOCK_50), .KEY(KEY), .pixel_enable(pixel_enable)
    );

    VGA_SYNC u_vga (
        .CLOCK_50(CLOCK_50), .KEY(KEY), .pixel_enable(pixel_enable),
        .pixel_x(pixel_x), .pixel_y(pixel_y), .video_on(video_on),
        .frame_tick(frame_tick), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS)
    );

    DinoGame u_game (
        .CLOCK_50(CLOCK_50), .KEY(KEY), .frame_tick(frame_tick),
        .game_data(game_data)
    );

    DinoDraw u_draw (
        .pixel_x(pixel_x), .pixel_y(pixel_y), .video_on(video_on),
        .game_data(game_data), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B)
    );
endmodule
