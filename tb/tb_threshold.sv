`timescale 1ns / 1ps

module tb_threshold;

    logic [11:0] gradient;
    logic [7:0]  edge_pixel;

    threshold #(
        .THRESHOLD(100)
    ) dut (
        .gradient(gradient),
        .edge_pixel(edge_pixel)
    );

    task automatic run_test(
        input string       name,
        input logic [11:0] grad,
        input logic [7:0]  expected
    );
        begin
            gradient = grad;
            #1;
            if (edge_pixel == expected)

                $display("[PASS] %-20s Gradient=%4d Edge=%3d", name, gradient, edge_pixel);
            else
                $display("[FAIL] %-20s Expected=%3d Got=%3d", name, expected, edge_pixel);
        end
    endtask

    initial begin
        $display("THRESHOLD TEST");
        run_test("Zero",          0,    0);
        run_test("Below",        99,    0);
        run_test("Equal",       100,    0);
        run_test("Above",       101,  255);
        run_test("Medium",      500,  255);
        run_test("Maximum",    2040,  255);
        $finish;
    end

endmodule
