`timescale 1ns / 1ps

module spi_tb;

  // Testbench signals (inputs to DUT)
  reg clk = 0;
  reg start = 0;
  reg [11:0] din = 12'h000;

  // DUT outputs
  wire cs, mosi, done, sclk;

  // Instantiate DUT
  spi uut (
    .clk(clk),
    .start(start),
    .din(din),
    .cs(cs),
    .mosi(mosi),
    .done(done),
    .sclk(sclk)
  );

  // Clock generator: 20 ns period (50 MHz)
  always #5 clk = ~clk;

  // Monitor SPI signals
  initial begin
    $display("Time\tCS\tSCLK\tMOSI\tDONE");
    $monitor("%0t\t%b\t%b\t%b\t%b", $time, cs, sclk, mosi, done);
  end

  // Stimulus block
  initial begin
    $display("Starting SPI Testbench");

    // Wait before starting
    #100;

    // First Transaction
    din = 12'hABC;    // Send 0xABC
    start = 1;        // Trigger transmission
    #20;
    start = 0;        // De-assert start

    wait(done);       // Wait until done = 1
    #100;             // Small delay

    // Second Transaction
    din = 12'h123;    // Send 0x123
    start = 1;
    #20;
    start = 0;

    wait(done);       // Wait until transmission completes

    #10000;
    $display("SPI Test Completed");
    $stop;
  end

endmodule