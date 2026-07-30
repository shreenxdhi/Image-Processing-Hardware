`timescale 1ns / 1ps

// Synchronous ROM synthesised as combinational logic by Yosys (no SRAM macro used).
module image_rom #(
    parameter IMG_WIDTH  = 642,
    parameter IMG_HEIGHT = 350,
    parameter DATA_WIDTH = 8,
    parameter MEM_FILE   = "./python_ref/image.mem"
)(
    input  wire                                      clk,
    input  wire [$clog2(IMG_WIDTH * IMG_HEIGHT)-1:0] addr,
    output reg  [DATA_WIDTH-1:0]                     pixel
);

    localparam DEPTH = IMG_WIDTH * IMG_HEIGHT;

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    initial $readmemh(MEM_FILE, mem);

    always @(posedge clk)
        pixel <= mem[addr];

endmodule
