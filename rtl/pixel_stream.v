`timescale 1ns / 1ps

module pixel_stream #(
    parameter IMG_WIDTH  = 642,
    parameter IMG_HEIGHT = 350,
    parameter ADDR_WIDTH = 18
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire [7:0]            pixel_in,
    output reg  [ADDR_WIDTH-1:0] address,
    output reg  [7:0]            pixel_out,
    output reg                   pixel_valid,
    output reg  [9:0]            x,
    output reg  [9:0]            y
);

    localparam DEPTH = IMG_WIDTH * IMG_HEIGHT;

    reg started;
    reg [ADDR_WIDTH-1:0] pixel_count;

    always @(posedge clk) begin
        if (rst) begin
            address     <= 0;
            x           <= 0;
            y           <= 0;
            pixel_out   <= 8'd0;
            pixel_valid <= 1'b0;
            started     <= 1'b0;
            pixel_count <= 0;
        end
        else if (!started) begin
            started <= 1'b1;
            address <= 1;
            pixel_valid <= 1'b0;
        end
        else if (pixel_count < DEPTH) begin
            pixel_out   <= pixel_in;
            pixel_valid <= 1'b1;
            pixel_count <= pixel_count + 1'b1;

            if (x == IMG_WIDTH-1) begin
                x <= 0;
                if (y != IMG_HEIGHT-1)
                    y <= y + 1'b1;
            end
            else begin
                x <= x + 1'b1;
            end

            if (pixel_count + 1 < DEPTH)
                address <= address + 1'b1;
        end
        else begin
            pixel_valid <= 1'b0;
        end
    end

endmodule
