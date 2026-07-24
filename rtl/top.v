`timescale 1ns / 1ps

module top #(
    parameter IMG_WIDTH  = 642,
    parameter IMG_HEIGHT = 350,
    parameter ADDR_WIDTH = 18,
    parameter THRESHOLD  = 100
)(
    input  wire        clk,
    input  wire        rst,
    output wire        edge_valid,
    output wire [7:0]  edge_pixel,
    output wire [11:0] gradient_out
);

    wire [ADDR_WIDTH-1:0] address;
    wire [7:0] rom_pixel;
    wire [7:0] pixel_out;
    wire pixel_valid;
    wire [9:0] x;
    wire [9:0] y;

    image_rom rom (
        .clk(clk),
        .addr(address),
        .pixel(rom_pixel)
    );

    pixel_stream #(
        .IMG_WIDTH(IMG_WIDTH),
        .IMG_HEIGHT(IMG_HEIGHT),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) streamer (
        .clk(clk),
        .rst(rst),
        .pixel_in(rom_pixel),
        .address(address),
        .pixel_out(pixel_out),
        .pixel_valid(pixel_valid),
        .x(x),
        .y(y)
    );

    image_pipeline #(
        .IMG_WIDTH(IMG_WIDTH),
        .THRESHOLD(THRESHOLD)
    ) pipeline (
        .clk(clk),
        .rst(rst),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_out),
        .edge_valid(edge_valid),
        .edge_pixel(edge_pixel),
        .gradient_out(gradient_out)
    );

endmodule
