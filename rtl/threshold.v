`timescale 1ns / 1ps

module threshold #(
    parameter THRESHOLD = 100
)(
    input  [11:0] gradient,
    output [7:0]  edge_pixel
);

    assign edge_pixel = (gradient > THRESHOLD) ? 8'd255 : 8'd0;

endmodule
