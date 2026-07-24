`timescale 1ns / 1ps

// Gate-level simulation testbench (VCD waveform dump omitted for performance)
module tb_top_gls;

    localparam int IMG_WIDTH  = 642;
    localparam int IMG_HEIGHT = 350;
    localparam int NUM_PIXELS = IMG_WIDTH * IMG_HEIGHT;

    logic clk;
    logic rst;
    logic        edge_valid;
    logic [7:0]  edge_pixel;
    logic [11:0] gradient_out;

    integer fd_edge;
    integer fd_grad;
    integer pixel_count;

    top dut (
        .clk(clk),
        .rst(rst),
        .edge_valid(edge_valid),
        .edge_pixel(edge_pixel),
        .gradient_out(gradient_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        fd_edge = $fopen("edge_output.mem", "w");
        fd_grad = $fopen("gradient_output.mem", "w");
        if (fd_edge == 0 || fd_grad == 0) begin
            $display("ERROR: Unable to open output files");
            $finish;
        end
    end

    initial begin
        rst = 1'b1;
        repeat (2) @(posedge clk);
        #1;
        rst = 1'b0;
    end

    initial pixel_count = 0;

    always @(posedge clk) begin
        if (edge_valid) begin
            $fdisplay(fd_edge, "%02X", edge_pixel);
            $fdisplay(fd_grad, "%0d", gradient_out);
            pixel_count <= pixel_count + 1;

            if (pixel_count % 10000 == 0)
                $display("Processed %0d pixels...", pixel_count);
        end
    end

    initial begin
        repeat (NUM_PIXELS + 100) @(posedge clk);
        $display("---------------------------------------");
        $display("Gate-Level Simulation Complete");
        $display("Pixels Written : %0d", pixel_count);
        $display("---------------------------------------");
        $fclose(fd_edge);
        $fclose(fd_grad);
        $finish;
    end

endmodule
