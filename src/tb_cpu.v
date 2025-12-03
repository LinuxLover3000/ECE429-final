//`timescale 1ns/1ps

module stimulus;

parameter T = 20;

reg [31:0] dataIn;
reg [1:0]  opsel, outsel;
reg [4:0]  addressA, addressB;
reg        asel, bsel, oen, clk;

wire [31:0] outPut;
wire        over;

integer handle3, desc3;

// Instantiate the design block
cpu proj(addressA, addressB, dataIn, asel, bsel, clk, opsel, outsel, oen, outPut, over);

// Clock
initial begin
  clk = 1'b1;
  forever #(T/2) clk = ~clk;   // symmetric clock for VCS
end

// VCS waveform dump
initial begin
  $dumpfile("stimulus_vcs_tb.vcd");
  $dumpvars(0, stimulus);
end

// Open log, run window, finish
initial begin
  handle3 = $fopen("stim_proj.out");
  #(500);
  $fclose(handle3);
  #1 $finish;
end

// Log snapshots to file
always begin
  desc3 = handle3;
  #1 $fdisplay(desc3, $time,
    "clk=%b, addressA=%0d, addressB=%0d, dataIn=%0d, opsel=%0d, outsel=%0d, asel=%0d, bsel=%0d, oen=%0d, OUT=%0d",
    clk, addressA, addressB, dataIn, opsel, outsel, asel, bsel, oen, outPut);
end

// Stimulate the Input Signals
initial begin
  // 1. store (-17) in [0]
  #T
  addressA = 5'b00000;
  addressB = 5'b00000;
  dataIn   = 32'hFFFF_FFEF;
  opsel    = 2'b01;
  outsel   = 2'b00;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 2. store 17 in [1]
  addressA = 5'b00000;
  addressB = 5'b00001;
  dataIn   = 32'h0000_0011;
  opsel    = 2'b01;
  outsel   = 2'b00;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 3. store 34 in [2]
  addressA = 5'b00000;
  addressB = 5'b00010;
  dataIn   = 32'h0000_0022;
  opsel    = 2'b01;
  outsel   = 2'b00;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 4. store 68 in [22]
  addressA = 5'b00000;
  addressB = 5'b10110;
  dataIn   = 32'h0000_0044;
  opsel    = 2'b01;
  outsel   = 2'b00;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 5. ADD [0][1]  FFFF_FFEF + 11 = 0
  addressA = 5'd0;
  addressB = 5'd1;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 2'b01;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)
  #(T*2)

  // 6. ADD [1][2] = 0 + 22 = 22
  addressA = 5'd1;
  addressB = 5'd2;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 2'b01;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 7. SUB [0][22] = FFFF_FFEF - 44 = FFFF_FFAB
  addressA = 5'd0;
  addressB = 5'd22;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 2'b01;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 8. READ [1] = 0
  addressA = 5'd1;
  addressB = 5'd1;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 2'b00;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 9. READ [2] = 34
  addressA = 5'd2;
  addressB = 5'd2;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 2'b00;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 10. READ [22] = FFFF_FFAB
  addressA = 5'd22;
  addressB = 5'd22;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 2'b00;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
end

endmodule
