`timescale 1ns/1ps

module tb_window_3x3;

    localparam int IMG_WIDTH  = 8;


    logic clk;
    logic rst;
    logic        pixel_valid;
    logic [7:0]  pixel_in;
    logic [9:0]  x;
    logic [9:0]  y;
    logic        window_valid;
    logic [7:0]  p00, p01, p02;
    logic [7:0]  p10, p11, p12;
    logic [7:0]  p20, p21, p22;

    window_3x3 #(
        .IMG_WIDTH(IMG_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),
        .window_valid(window_valid),
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_window_3x3.vcd");
        $dumpvars(0, tb_window_3x3);
    end

    initial begin
        rst         = 1;
        pixel_valid = 0;
        pixel_in    = 0;
        x           = 0;
        y           = 0;

        repeat (2) @(posedge clk);
        rst         = 0;
        pixel_valid = 1;

        $display("In  X  Y | 3x3 Window");
        for (int i = 1; i <= 40; i++) begin
            @(negedge clk);
            pixel_in = 8'(i);
            @(posedge clk);

            if (window_valid) begin
                $display("%3d %2d %2d | %3d %3d %3d | %3d %3d %3d | %3d %3d %3d",
                    pixel_in, x, y,
                    p00, p01, p02,
                    p10, p11, p12,
                    p20, p21, p22
                );
            end

            if (x == 10'(IMG_WIDTH-1)) begin

                x = 0;
                y = y + 1;
            end else begin
                x = x + 1;
            end
        end
        $finish;
    end

endmodule
