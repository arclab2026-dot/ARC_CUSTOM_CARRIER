`timescale 1ns/1ps
module arc_controlled_counter8 (
    input  wire       clk,
    input  wire       resetn,
    input  wire [7:0] control,
    output reg  [7:0] count
);

wire enable = control[0];
wire clear  = control[1];

always @(posedge clk) begin
    if (!resetn)
        count <= 8'h00;
    else if (clear)
        count <= 8'h00;
    else if (enable)
        count <= count + 1'b1;
end

endmodule
