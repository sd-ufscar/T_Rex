// Conversao e correcao do VGA_SYNC.vhd fornecido na disciplina.
// 640x480; 800 clocks/pixels x 525 linhas; taxa de ~59,52 Hz.
// CLOCK_50 permanece como unico clock: pixel_enable avanca a cada 2 ciclos.
module VGA_SYNC (
    input wire CLOCK_50,
    input wire [3:0] KEY,
    input wire pixel_enable,
    output reg [9:0] pixel_x,
    output reg [9:0] pixel_y,
    output wire video_on,
    output wire frame_tick,
    output wire VGA_HS,
    output wire VGA_VS
);
    assign video_on = (pixel_x < 10'd640) && (pixel_y < 10'd480);
    assign VGA_HS = ~((pixel_x >= 10'd656) && (pixel_x < 10'd752));
    assign VGA_VS = ~((pixel_y >= 10'd490) && (pixel_y < 10'd492));

    // Pulso de um ciclo de 50 MHz, uma vez por quadro.
    assign frame_tick = pixel_enable &&
                        (pixel_x == 10'd0) && (pixel_y == 10'd0);

    always @(posedge CLOCK_50 or negedge KEY[3]) begin
        if (!KEY[3]) begin
            pixel_x <= 10'd0;
            pixel_y <= 10'd0;
        end else if (pixel_enable) begin
            if (pixel_x == 10'd799) begin
                pixel_x <= 10'd0;
                if (pixel_y == 10'd524) pixel_y <= 10'd0;
                else                    pixel_y <= pixel_y + 10'd1;
            end else begin
                pixel_x <= pixel_x + 10'd1;
            end
        end
    end
endmodule
