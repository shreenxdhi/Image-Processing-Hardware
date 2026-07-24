`timescale 1ns/1ps

module tb_sobel_filter;

    logic [7:0] p00, p01, p02;
    logic [7:0] p10, p11, p12;
    logic [7:0] p20, p21, p22;
    logic signed [10:0] gx;
    logic signed [10:0] gy;

    sobel_core dut (
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22),
        .gx(gx),
        .gy(gy)
    );

    task automatic run_test(
        input string name,
        input logic [7:0] tp00, tp01, tp02,
        input logic [7:0] tp10, tp11, tp12,
        input logic [7:0] tp20, tp21, tp22,
        input logic signed [10:0] expected_gx,
        input logic signed [10:0] expected_gy
    );
        begin
            p00 = tp00; p01 = tp01; p02 = tp02;
            p10 = tp10; p11 = tp11; p12 = tp12;
            p20 = tp20; p21 = tp21; p22 = tp22;
            #1;
            if ((gx == expected_gx) && (gy == expected_gy))

                $display("[PASS] %-20s Gx=%4d Gy=%4d", name, gx, gy);
            else
                $display("[FAIL] %-20s Expected: Gx=%4d Gy=%4d Got: Gx=%4d Gy=%4d", name, expected_gx, expected_gy, gx, gy);
        end
    endtask

    initial begin
        $display("SOBEL FILTER TEST");
        run_test("Sequential",      10,20,30, 40,50,60, 70,80,90,   80, -240);
        run_test("Uniform",         100,100,100, 100,100,100, 100,100,100, 0, 0);
        run_test("Vertical Edge",    0, 0,255, 0, 0,255, 0, 0,255, 1020,    0);
        run_test("Horizontal Edge",  255,255,255, 0,0,0, 0,0,0,     0, 1020);
        $dumpfile("sobel_filter.vcd");
        $dumpvars(0, tb_sobel_filter);
        $finish;
    end

endmodule
