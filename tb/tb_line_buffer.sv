`timescale 1ns / 1ps

module tb_line_buffer;

    localparam int IMG_WIDTH = 8;

    logic       clk;
    logic       rst;
    logic       pixel_valid;
    logic [7:0] pixel_in;
    logic [7:0] pixel_out;
    logic       valid_out;

    line_buffer #(
        .IMG_WIDTH(IMG_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),
        .pixel_out(pixel_out),
        .valid_out(valid_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst         = 1'b1;
        pixel_valid = 1'b0;
        pixel_in    = '0;

        repeat (2) @(posedge clk);
        rst         = 1'b0;
        pixel_valid = 1'b1;

        $display("Cycle\tInput\tOutput\tValid");
        for (int i = 1; i <= 20; i++) begin
            @(negedge clk);
            pixel_in = 8'(i);

            @(posedge clk);
            if (valid_out)
                $display("%0d\t%0d\t%0d\t1", i, pixel_in, pixel_out);
            else
                $display("%0d\t%0d\tX\t0", i, pixel_in);
        end
        $finish;
    end

endmodule
