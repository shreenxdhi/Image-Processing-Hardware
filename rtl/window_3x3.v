`timescale 1ns / 1ps

module window_3x3 #(
    parameter IMG_WIDTH = 642
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       pixel_valid,
    input  wire [7:0] pixel_in,
    output wire       window_valid,
    output reg  [7:0] p00, p01, p02,
    output reg  [7:0] p10, p11, p12,
    output reg  [7:0] p20, p21, p22
);

    wire [7:0] line1_pixel, line2_pixel;
    wire       line1_valid, line2_valid;

    line_buffer #(.IMG_WIDTH(IMG_WIDTH)) lb1 (
        .clk        (clk),
        .rst        (rst),
        .pixel_valid(pixel_valid),
        .pixel_in   (pixel_in),
        .pixel_out  (line1_pixel),
        .valid_out  (line1_valid)
    );

    line_buffer #(.IMG_WIDTH(IMG_WIDTH)) lb2 (
        .clk        (clk),
        .rst        (rst),
        .pixel_valid(line1_valid),
        .pixel_in   (line1_pixel),
        .pixel_out  (line2_pixel),
        .valid_out  (line2_valid)
    );

    // Column counter increments on every pixel_valid to stay aligned with
    // row boundaries regardless of whether the line buffers are filled.
    localparam COL_W = $clog2(IMG_WIDTH);

    reg  [COL_W-1:0] col;
    wire [COL_W-1:0] col_next;

    assign col_next = (col == IMG_WIDTH - 1) ? {COL_W{1'b0}} : col + 1'b1;

    always @(posedge clk) begin
        if (rst) begin
            p00 <= 0; p01 <= 0; p02 <= 0;
            p10 <= 0; p11 <= 0; p12 <= 0;
            p20 <= 0; p21 <= 0; p22 <= 0;
            col <= 0;
        end else if (pixel_valid) begin
            p00 <= p01; p01 <= p02; p02 <= line2_pixel;
            p10 <= p11; p11 <= p12; p12 <= line1_pixel;
            p20 <= p21; p21 <= p22; p22 <= pixel_in;
            col <= col_next;
        end
    end

    // window_valid is registered to match the one-cycle data latency of the
    // shift registers. It is masked for the two leftmost columns of each row
    // where p00..p02 contain stale data from the previous row.
    reg window_valid_r;
    assign window_valid = window_valid_r;

    always @(posedge clk) begin
        if (rst)
            window_valid_r <= 1'b0;
        else if (pixel_valid)
            window_valid_r <= line2_valid && (col >= 2);
        else
            window_valid_r <= 1'b0;
    end

endmodule
