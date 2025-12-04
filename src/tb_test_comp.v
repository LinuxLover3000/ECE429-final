//`timescale 1ns/1ps

module stimulus;

parameter T = 20;

reg [31:0] dataIn;
reg [1:0]  opsel;
reg [2:0]  outsel;
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
  #(1400);
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
  //Delay by T
  #T
  
  // 1. store 0A20_1B19 in [0]
  addressA = 5'b00000;
  addressB = 5'b00000;
  dataIn   = 32'h0A20_1B19;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 2. store 7777_8888 in [1]
  addressA = 5'b00000;
  addressB = 5'b00001;
  dataIn   = 32'h7777_8888;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 3. store 8888_7777 in [2]
  addressA = 5'b00000;
  addressB = 5'b00010;
  dataIn   = 32'h8888_7777;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 4. store 0101_0101 in [3]
  addressA = 5'b00000;
  addressB = 5'b00011;
  dataIn   = 32'h0101_0101;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 5. store 10F0_10F0 in [4]
  addressA = 5'b00000;
  addressB = 5'b00100;
  dataIn   = 32'h10F0_10F0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 6. store FFFF_0001 in [5]
  addressA = 5'b00000;
  addressB = 5'b00101;
  dataIn   = 32'hFFFF_0001;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 7. store 0011_2233 in [6]
  addressA = 5'b00000;
  addressB = 5'b00110;
  dataIn   = 32'h0011_2233;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 8. store 3322_1100 in [7]
  addressA = 5'b00000;
  addressB = 5'b00111;
  dataIn   = 32'h3322_1100;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 9. store 12A3_18B8 in [8]
  addressA = 5'b00000;
  addressB = 5'b01000;
  dataIn   = 32'h12A3_18B8;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 10. store 0704_1776 in [9]
  addressA = 5'b00000;
  addressB = 5'b01001;
  dataIn   = 32'h0704_1776;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 11. store 0304_1837 in [10]
  addressA = 5'b00000;
  addressB = 5'b01010;
  dataIn   = 32'h0304_1837;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b0;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 12. ADD [1][2]
  addressA = 5'd1;
  addressB = 5'd2;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b001;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 13. SUB [4][3]
  addressA = 5'd4;
  addressB = 5'd3;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b001;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 14. ADD [7][6]
  addressA = 5'd7;
  addressB = 5'd6;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b001;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 15. CMP [2][5]
  addressA = 5'd2;
  addressB = 5'd5;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b100;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 16. ADD [1][4]
  addressA = 5'd1;
  addressB = 5'd4;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b001;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 17. SUB [2][1]
  addressA = 5'd2;
  addressB = 5'd1;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b001;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 18. READ [1]
  addressA = 5'd1;
  addressB = 5'd1;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 19. READ [0]
  addressA = 5'd0;
  addressB = 5'd0;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 20. READ [8]
  addressA = 5'd8;
  addressB = 5'd8;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 21. CMP [6][3]
  addressA = 5'd6;
  addressB = 5'd3;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b100;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 22. READ [9]
  addressA = 5'd9;
  addressB = 5'd9;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 23. READ [10]
  addressA = 5'd10;
  addressB = 5'd10;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 24. READ [2]
  addressA = 5'd2;
  addressB = 5'd2;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 25. READ [3]
  addressA = 5'd3;
  addressB = 5'd3;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 26. READ [6]
  addressA = 5'd6;
  addressB = 5'd6;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 27. READ [5]
  addressA = 5'd5;
  addressB = 5'd5;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 28. CMP [1][3]
  addressA = 5'd1;
  addressB = 5'd3;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b100;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 29. CMP [5][4]
  addressA = 5'd5;
  addressB = 5'd4;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b100;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 30. READ [5]
  addressA = 5'd5;
  addressB = 5'd5;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 31. CMP [10][9]
  addressA = 5'd10;
  addressB = 5'd9;
  dataIn   = 32'd0;
  opsel    = 2'b00;
  outsel   = 3'b100;
  asel     = 1'b1;
  bsel     = 1'b1;
  oen      = 1'b1;
  #(T*2)

  // 32. READ [3]
  addressA = 5'd3;
  addressB = 5'd3;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 33. READ [4]
  addressA = 5'd4;
  addressB = 5'd4;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
  #(T*2)

  // 34. READ [9]
  addressA = 5'd9;
  addressB = 5'd9;
  dataIn   = 32'd0;
  opsel    = 2'b01;
  outsel   = 3'b000;
  asel     = 1'b1;
  bsel     = 1'b0;
  oen      = 1'b1;
end

endmodule
