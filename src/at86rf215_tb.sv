`timescale 1 ns / 1 ps
//`include "at86rf215_tx.sv"
module at86rf215_tb;
// Parameters of the DUT
localparam string DATA_RATE = "DDR";
localparam integer TXD_WIDTH = 2;
localparam C_S_AXIS_TDATA_WIDTH = 32;
localparam integer FRACTIONAL_BITS = 13;

// Testbench Signals
logic [3:0] samp_rate;
logic [TXD_WIDTH - 1 : 0] txd;
logic underflow;
logic aclk;
logic aresetn;

logic s00_axis_tready;
logic [31 - 1 : 0] s00_axis_tdata;
logic s00_axis_tlast;
logic s00_axis_tvalid;


// Instantiate the Unit Under Test (UUT)
  at86rf215_tx #(
    .DATA_RATE (DATA_RATE),
    .TXD_WIDTH(TXD_WIDTH),
    .FRACTIONAL_BITS(FRACTIONAL_BITS)
  ) uut (
    .samp_rate(samp_rate),
    .txd(txd),
    .underflow(underflow),
    .aclk(aclk),
    .aresetn(aresetn),
    .s00_axis_tready(s00_axis_tready),
    .s00_axis_tdata(s00_axis_tdata),
    .s00_axis_tlast(s00_axis_tlast),
    .s00_axis_tvalid(s00_axis_tvalid)
  );

  /* Clock generation */
  always #5 aclk = ~aclk;

  initial begin
    aclk = 0;
    s00_axis_tdata = 0;
    s00_axis_tlast = 0;
    s00_axis_tvalid = 0;
    samp_rate = 5'b10001;

    /* Reset the system */
    @(posedge aclk);
    aresetn = 1;
    @(posedge aclk);
    aresetn = 0;
    @(posedge aclk);
    aresetn = 1;
    /* Set the slave input */
    @(posedge aclk);
    s00_axis_tdata = 32'hEFFFFFFF;
    @(posedge aclk);
    @(posedge aclk);
    for (int i = 0; i < 5; i++) begin

        s00_axis_tvalid = 0;
        @(posedge aclk);

        s00_axis_tvalid = 1;

        @(posedge aclk);
        if (i==4) begin
            s00_axis_tlast = 1;
        end
        @(posedge aclk);
        s00_axis_tvalid = 0;
        s00_axis_tlast = 0;
        repeat (20/TXD_WIDTH) @(posedge aclk);
    end
    s00_axis_tvalid = 0;
    
    repeat (17) @(posedge aclk);
    for (int i = 0; i < 5; i++) begin

        s00_axis_tvalid = 0;
        @(posedge aclk);

        s00_axis_tvalid = 1;

        @(posedge aclk);
        if (i==4) begin
            s00_axis_tlast = 1;
        end
        @(posedge aclk);
        s00_axis_tvalid = 0;
        s00_axis_tlast = 0;
        repeat (20/TXD_WIDTH) @(posedge aclk);
    end
    $finish;
  end
endmodule