`timescale 1ns / 1ps

module tb_gradient_mag;

    logic signed [10:0] gx;
    logic signed [10:0] gy;
    logic [11:0]        gradient;

    gradient_mag dut (
        .gx(gx),
        .gy(gy),
        .gradient(gradient)
    );

    task automatic run_test(
        input string              name,
        input logic signed [10:0] gx_in,
        input logic signed [10:0] gy_in,
        input logic        [11:0] expected
    );
        begin
            gx = gx_in;
            gy = gy_in;
            #1;
            if (gradient == expected)

                $display("[PASS] %-20s Gradient = %0d", name, gradient);
            else
                $display("[FAIL] %-20s Expected = %0d Got = %0d", name, expected, gradient);
        end
    endtask

    initial begin
        $display("GRADIENT MAGNITUDE TEST");
        run_test("Positive",      80,   240, 320);
        run_test("Negative Gx",  -80,   240, 320);
        run_test("Negative Gy",   80,  -240, 320);
        run_test("Both Negative",-80,  -240, 320);
        run_test("Zero",           0,     0,   0);
        run_test("Max",         1020,  1020, 2040);
        $finish;
    end

endmodule
