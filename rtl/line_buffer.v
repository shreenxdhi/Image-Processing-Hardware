`timescale 1ns / 1ps

module line_buffer #(
    parameter IMG_WIDTH = 642
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       pixel_valid,
    input  wire [7:0] pixel_in,
    output wire [7:0] pixel_out,
    output wire       valid_out
);

    localparam PTR_WIDTH               = $clog2(IMG_WIDTH);
    localparam [PTR_WIDTH-1:0] PTR_MAX = IMG_WIDTH - 1;

    reg [7:0]           line_mem [0:IMG_WIDTH-1];
    reg [PTR_WIDTH-1:0] ptr;
    reg                 filled;

    integer i;
    initial begin
        for (i = 0; i < IMG_WIDTH; i = i + 1)
            line_mem[i] = 8'd0;
    end

    /* verilator lint_off WIDTHTRUNC */
    assign pixel_out = line_mem[ptr];
    /* verilator lint_on WIDTHTRUNC */

    assign valid_out = filled & pixel_valid;

    always @(posedge clk) begin
        if (rst) begin
            ptr    <= 0;
            filled <= 1'b0;
        end else if (pixel_valid) begin
            /* verilator lint_off WIDTHTRUNC */
            line_mem[ptr] <= pixel_in;
            /* verilator lint_on WIDTHTRUNC */

            if (ptr == PTR_MAX) begin
                ptr    <= 0;
                filled <= 1'b1;
            end else begin
                ptr <= ptr + 1'b1;
            end
        end
    end

endmodule
