`timescale 1ns / 1ps

module sobel_core (
    input  [7:0] p00, p01, p02,
    input  [7:0] p10, p11, p12,
    input  [7:0] p20, p21, p22,

    output signed [10:0] gx,
    output signed [10:0] gy
);

    // Extend all pixels to 11-bit signed values
    wire signed [10:0] s00 = {3'b000, p00};
    wire signed [10:0] s01 = {3'b000, p01};
    wire signed [10:0] s02 = {3'b000, p02};

    wire signed [10:0] s10 = {3'b000, p10};
    wire signed [10:0] s12 = {3'b000, p12};

    wire signed [10:0] s20 = {3'b000, p20};
    wire signed [10:0] s21 = {3'b000, p21};
    wire signed [10:0] s22 = {3'b000, p22};

    // Sobel X
    assign gx =
          -s00 + s02
        - (s10 <<< 1) + (s12 <<< 1)
        - s20 + s22;

    // Sobel Y
    assign gy =
           s00 + (s01 <<< 1) + s02
         - s20 - (s21 <<< 1) - s22;

endmodule
