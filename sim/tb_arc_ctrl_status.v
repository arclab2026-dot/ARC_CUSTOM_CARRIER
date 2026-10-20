`timescale 1ns/1ps

module tb_arc_ctrl_status;

reg clk;
reg resetn;

reg  [3:0]  awaddr;
reg         awvalid;
wire        awready;

reg  [31:0] wdata;
reg  [3:0]  wstrb;
reg         wvalid;
wire        wready;

wire [1:0]  bresp;
wire        bvalid;
reg         bready;

reg  [3:0]  araddr;
reg         arvalid;
wire        arready;

wire [31:0] rdata;
wire [1:0]  rresp;
wire        rvalid;
reg         rready;

wire [7:0] control_o;
reg  [7:0] status_i;

arc_ctrl_status_v1_0 dut (
    .control_o(control_o),
    .status_i(status_i),

    .s_axi_aclk(clk),
    .s_axi_aresetn(resetn),

    .s_axi_awaddr(awaddr),
    .s_axi_awprot(3'b000),
    .s_axi_awvalid(awvalid),
    .s_axi_awready(awready),

    .s_axi_wdata(wdata),
    .s_axi_wstrb(wstrb),
    .s_axi_wvalid(wvalid),
    .s_axi_wready(wready),

    .s_axi_bresp(bresp),
    .s_axi_bvalid(bvalid),
    .s_axi_bready(bready),

    .s_axi_araddr(araddr),
    .s_axi_arprot(3'b000),
    .s_axi_arvalid(arvalid),
    .s_axi_arready(arready),

    .s_axi_rdata(rdata),
    .s_axi_rresp(rresp),
    .s_axi_rvalid(rvalid),
    .s_axi_rready(rready)
);

initial clk = 0;
always #5 clk = ~clk;

task axi_write;
    input [3:0] addr;
    input [31:0] data;
begin
    @(posedge clk);

    awaddr  <= addr;
    awvalid <= 1;
    wdata   <= data;
    wstrb   <= 4'hF;
    wvalid  <= 1;
    bready  <= 1;

    wait (awready && wready);

    @(posedge clk);

    awvalid <= 0;
    wvalid  <= 0;

    wait (bvalid);

    @(posedge clk);
    bready <= 0;
end
endtask

task axi_read;
    input [3:0] addr;
    output [31:0] data;
begin
    @(posedge clk);

    araddr  <= addr;
    arvalid <= 1;
    rready  <= 1;

    wait (arready);

    @(posedge clk);
    arvalid <= 0;

    wait (rvalid);

    data = rdata;

    @(posedge clk);
    rready <= 0;
end
endtask

reg [31:0] read_value;

initial begin

    resetn = 0;

    awaddr  = 0;
    awvalid = 0;
    wdata   = 0;
    wstrb   = 0;
    wvalid  = 0;
    bready  = 0;

    araddr  = 0;
    arvalid = 0;
    rready  = 0;

    status_i = 8'h00;

    repeat (4) @(posedge clk);
    resetn = 1;

    // CONTROL = RUN
    axi_write(4'h0, 32'h00000001);

    if (control_o !== 8'h01) begin
        $display("ERROR: CONTROL write failed");
        $finish;
    end

    // Provide live PL status.
    status_i = 8'hA5;

    // Read STATUS at offset 0x04.
    axi_read(4'h4, read_value);

    if (read_value !== 32'h000000A5) begin
        $display("ERROR: STATUS read failed value=%h", read_value);
        $finish;
    end

    // CONTROL = CLEAR
    axi_write(4'h0, 32'h00000002);

    if (control_o !== 8'h02) begin
        $display("ERROR: CONTROL clear failed");
        $finish;
    end

    $display("CONTROL_WRITE_TEST=PASS");
    $display("STATUS_READ_TEST=PASS");
    $display("CONTROL_CLEAR_TEST=PASS");
    $display("ARC_CUSTOM_REGISTER_SIM_PASS=1");

    $finish;
end

endmodule
