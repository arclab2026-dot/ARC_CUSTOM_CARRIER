`timescale 1ns/1ps

module tb_arc_ps_pl_system;

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
wire [7:0] count;

/* ---------------------------------------------------------
 * Custom AXI4-Lite CONTROL / STATUS peripheral
 * --------------------------------------------------------- */

arc_ctrl_status_v1_0 dut_regs (
    .control_o(control_o),
    .status_i(count),

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

/* ---------------------------------------------------------
 * Custom Programmable Logic counter
 * --------------------------------------------------------- */

arc_controlled_counter8 dut_counter (
    .clk(clk),
    .resetn(resetn),
    .control(control_o),
    .count(count)
);

/* 100 MHz clock */
initial clk = 1'b0;
always #5 clk = ~clk;

/* ---------------------------------------------------------
 * Processor-style AXI4-Lite write
 * --------------------------------------------------------- */

task axi_write;
    input [3:0] addr;
    input [31:0] data;
begin
    @(posedge clk);

    awaddr  <= addr;
    awvalid <= 1'b1;

    wdata   <= data;
    wstrb   <= 4'hF;
    wvalid  <= 1'b1;

    bready  <= 1'b1;

    wait (awready && wready);

    @(posedge clk);

    awvalid <= 1'b0;
    wvalid  <= 1'b0;

    wait (bvalid);

    @(posedge clk);
    bready <= 1'b0;
end
endtask

/* ---------------------------------------------------------
 * Processor-style AXI4-Lite read
 * --------------------------------------------------------- */

task axi_read;
    input [3:0] addr;
    output [31:0] data;
begin
    @(posedge clk);

    araddr  <= addr;
    arvalid <= 1'b1;
    rready  <= 1'b1;

    wait (arready);

    @(posedge clk);
    arvalid <= 1'b0;

    wait (rvalid);

    data = rdata;

    @(posedge clk);
    rready <= 1'b0;
end
endtask

reg [31:0] read_value;
reg [7:0] hold_value_1;
reg [7:0] hold_value_2;

initial begin

    resetn = 1'b0;

    awaddr  = 0;
    awvalid = 0;

    wdata   = 0;
    wstrb   = 0;
    wvalid  = 0;
    bready  = 0;

    araddr  = 0;
    arvalid = 0;
    rready  = 0;

    $display("============================================================");
    $display("ARC PS <-> PL SYSTEM SIMULATION");
    $display("============================================================");

    $display("[%0t ns] Reset asserted", $time);

    repeat (4) @(posedge clk);

    resetn = 1'b1;

    $display("[%0t ns] Reset released", $time);

    /* -----------------------------------------------------
     * RUN
     * ----------------------------------------------------- */

    axi_write(4'h0, 32'h00000001);

    $display("[%0t ns] PS WRITE: CONTROL = 0x01 (RUN)", $time);
    $display("[%0t ns] PL control_o = 0x%02h", $time, control_o);

    repeat (8) @(posedge clk);

    axi_read(4'h4, read_value);

    $display("[%0t ns] PS READ: STATUS = 0x%02h", $time,
             read_value[7:0]);

    if (read_value[7:0] == 8'h00) begin
        $display("ERROR: counter did not run");
        $finish;
    end

    /* -----------------------------------------------------
     * HOLD
     * ----------------------------------------------------- */

    axi_write(4'h0, 32'h00000000);

    $display("[%0t ns] PS WRITE: CONTROL = 0x00 (HOLD)", $time);

    repeat (2) @(posedge clk);

    axi_read(4'h4, read_value);
    hold_value_1 = read_value[7:0];

    $display("[%0t ns] HOLD STATUS #1 = 0x%02h",
             $time, hold_value_1);

    repeat (5) @(posedge clk);

    axi_read(4'h4, read_value);
    hold_value_2 = read_value[7:0];

    $display("[%0t ns] HOLD STATUS #2 = 0x%02h",
             $time, hold_value_2);

    if (hold_value_1 !== hold_value_2) begin
        $display("ERROR: counter changed while HOLD was active");
        $finish;
    end

    /* -----------------------------------------------------
     * CLEAR
     * ----------------------------------------------------- */

    axi_write(4'h0, 32'h00000002);

    $display("[%0t ns] PS WRITE: CONTROL = 0x02 (CLEAR)", $time);

    repeat (2) @(posedge clk);

    axi_read(4'h4, read_value);

    $display("[%0t ns] PS READ: STATUS after CLEAR = 0x%02h",
             $time, read_value[7:0]);

    if (read_value[7:0] !== 8'h00) begin
        $display("ERROR: counter did not clear");
        $finish;
    end

    $display("------------------------------------------------------------");
    $display("RUN_TEST=PASS");
    $display("HOLD_TEST=PASS");
    $display("CLEAR_TEST=PASS");
    $display("PS_TO_PL_CONTROL_PASS=1");
    $display("PL_TO_PS_STATUS_PASS=1");
    $display("ARC_PS_PL_SYSTEM_SIM_PASS=1");
    $display("============================================================");

    $finish;
end

endmodule
