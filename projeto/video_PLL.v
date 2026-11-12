// Adaptacao em Verilog do papel do Video_PLL.vhd da aula.
// Nao usa altpll nem bibliotecas Altera: habilita UM pixel a cada 2 clocks
// de 50 MHz. Todo o projeto permanece no dominio CLOCK_50 (mais seguro).
// Nao e um PLL fisico, nem gera um novo clock externo de 25 MHz.
module video_PLL (
    input wire CLOCK_50,
    input wire [3:0] KEY,
    output reg pixel_enable
);
    always @(posedge CLOCK_50 or negedge KEY[3]) begin
        if (!KEY[3]) pixel_enable <= 1'b0;
        else         pixel_enable <= ~pixel_enable;
    end
endmodule
