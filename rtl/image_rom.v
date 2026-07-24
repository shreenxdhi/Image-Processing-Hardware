`timescale 1ns / 1ps

module image_rom #(
    parameter IMG_WIDTH  = 642,
    parameter IMG_HEIGHT = 350,
    parameter DATA_WIDTH = 8,
    parameter MEM_FILE   = "./python_ref/image.mem"
)(
    input  wire clk,
    input  wire [$clog2(IMG_WIDTH*IMG_HEIGHT)-1:0] addr,
    output reg  [DATA_WIDTH-1:0] pixel
);
    localparam DEPTH = IMG_WIDTH * IMG_HEIGHT;
    // Image memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    initial begin
        $readmemh(MEM_FILE, mem);
    end
    always @(posedge clk) begin
        pixel <= mem[addr];
    end
endmodule
