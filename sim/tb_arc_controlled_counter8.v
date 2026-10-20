`timescale 1ns/1ps

module tb_arc_controlled_counter8;

reg        clk;
reg        resetn;
reg  [7:0] control;
wire [7:0] count;

arc_controlled_counter8 dut (
    .clk     (clk),
    .resetn  (resetn),
    .control (control),
    .count   (count)
);

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
    resetn = 1'b0;
    control = 8'h00;

    // Reset
    repeat (2) @(posedge clk);
    resetn = 1'b1;

    repeat (2) @(posedge clk);
    #1;

    if (count !== 8'h00) begin
        $display("ERROR: reset test failed count=%0d", count);
        $finish;
    end

    // Enable counter
    control = 8'h01;

    repeat (5) @(posedge clk);
    #1;

    if (count !== 8'h05) begin
        $display("ERROR: enable test failed count=%0d", count);
        $finish;
    end

    // Hold counter
    control = 8'h00;

    repeat (3) @(posedge clk);
    #1;

    if (count !== 8'h05) begin
        $display("ERROR: hold test failed count=%0d", count);
        $finish;
    end

    // Clear counter
    control = 8'h02;

    @(posedge clk);
    #1;

    if (count !== 8'h00) begin
        $display("ERROR: clear test failed count=%0d", count);
        $finish;
    end

    $display("RESET_TEST=PASS");
    $display("ENABLE_TEST=PASS");
    $display("HOLD_TEST=PASS");
    $display("CLEAR_TEST=PASS");
    $display("ARC_CONTROLLED_COUNTER_SIM_PASS=1");

    $finish;
end

endmodule
