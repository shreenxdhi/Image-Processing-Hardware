`timescale 1ns / 1ps

module tb_pixel_stream;

    localparam int ADDR_WIDTH = 18;
    localparam int IMG_WIDTH  = 642;
    localparam int IMG_HEIGHT = 350;

    logic clk;
    logic rst;
    logic [ADDR_WIDTH-1:0] address;
    logic [7:0] rom_pixel;
    logic [7:0] pixel_out;
    logic pixel_valid;
    logic [9:0] x;
    logic [9:0] y;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

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

    initial begin
        $dumpfile("pixel_stream.vcd");
        $dumpvars(0, tb_pixel_stream);
    end

    initial begin
        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;

        $display("Cycle\tAddr\tX\tY\tPixel");
        for (int cycle = 0; cycle < 700; cycle++) begin
            @(posedge clk);
            if (pixel_valid)
                $display("%0d\t%0d\t%0d\t%0d\t%0d", cycle, address - 1, x, y, pixel_out);
        end
        $finish;
    end

endmodule
