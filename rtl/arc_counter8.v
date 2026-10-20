module arc_counter8 (
    input  wire       clk,
    input  wire       resetn,
    output reg  [7:0] count
);

always @(posedge clk) begin
    if (!resetn)
        count <= 8'h00;
    else
        count <= count + 1'b1;
end

endmodule
