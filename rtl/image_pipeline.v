`timescale 1ns / 1ps

module image_pipeline #(
    parameter IMG_WIDTH = 642,
    parameter THRESHOLD = 100
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        pixel_valid,
    input  wire [7:0]  pixel_in,
    output wire        edge_valid,
    output wire [7:0]  edge_pixel,
    output wire [11:0] gradient_out
);

    wire window_valid;
    wire [7:0] p00, p01, p02;
    wire [7:0] p10, p11, p12;
    wire [7:0] p20, p21, p22;

    wire signed [10:0] gx;
    wire signed [10:0] gy;
    wire [11:0] gradient;

    window_3x3 #(
        .IMG_WIDTH(IMG_WIDTH)
    ) window_inst (
        .clk(clk),
        .rst(rst),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),
        .window_valid(window_valid),
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22)
    );

    sobel_core sobel_inst (
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22),
        .gx(gx),
        .gy(gy)
    );

    gradient_mag gradient_inst (
        .gx(gx),
        .gy(gy),
        .gradient(gradient)
    );

    threshold #(
        .THRESHOLD(THRESHOLD)
    ) threshold_inst (
        .gradient(gradient),
        .edge_pixel(edge_pixel)
    );

    assign gradient_out = gradient;
    assign edge_valid = window_valid;

endmodule
