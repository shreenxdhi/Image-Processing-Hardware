`timescale 1ns / 1ps

module gradient_mag #(
    parameter OUT_WIDTH = 12
)(
    input  signed [10:0] gx,
    input  signed [10:0] gy,
    output [OUT_WIDTH-1:0] gradient
);

    wire [10:0] abs_gx;
    wire [10:0] abs_gy;

    assign abs_gx = gx[10] ? -gx : gx;
    assign abs_gy = gy[10] ? -gy : gy;

    // Approximate magnitude: |gx| + |gy|
    assign gradient = {1'b0, abs_gx} + {1'b0, abs_gy};

endmodule
