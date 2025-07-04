`timescale 1ns / 1ps

module i2c_tb;

  // Testbench signals
  reg clk = 0;
  reg rst = 0;
  reg newd = 0;
  reg ack = 1;
  reg wr = 1;

  wire scl;
  wire sda;           // I2C bidirectional net
  wire [7:0] rdata;
  wire done;

  reg [7:0] wdata = 8'hA5;
  reg [6:0] addr  = 7'b1010101;

  // Internal driver signal for SDA
  reg sda_drive_en = 0;
  reg sda_drive_val = 1'b1;

  // Model tri-state SDA line for testbench
  assign sda = (sda_drive_en) ? sda_drive_val : 1'bz;

  // Instantiate DUT
  i2c dut (
    .clk(clk),
    .rst(rst),
    .newd(newd),
    .ack(ack),
    .wr(wr),
    .scl(scl),
    .sda(sda),
    .wdata(wdata),
    .addr(addr),
    .rdata(rdata),
    .done(done)
  );

  // Clock generation: 100MHz
  always #5 clk = ~clk;

  task give_ack;
    begin
      ack = 1;
      #20;   // Acknowledge high
      ack = 0;
    end
  endtask

  initial begin
    $display(">>> Starting I2C Testbench");
    rst = 1;
    #20 rst = 0;

    // ==============================
    // WRITE Operation
    // ==============================
    $display("[WRITE] Sending data 0x%h to address 0x%h", wdata, addr);
    wr = 1;
    newd = 1;
    #10 newd = 0;

    repeat (2) give_ack(); // Simulate ack for address and data

    wait(done == 1);
    $display("[WRITE] DONE");

    #50;

    // ==============================
    // READ Operation
    // ==============================
    wr = 0;
    newd = 1;
    #10 newd = 0;

    // Enable testbench to drive SDA line (DUT reads from it)
    sda_drive_en = 1;

    // Send 8 bits of fake data
    repeat (8) begin
      sda_drive_val = $random % 2; // Generate dummy read bits
      #20;
    end

    sda_drive_en = 0; // Release SDA after sending

    wait(done == 1);
    $display("[READ] DONE. Data received = 0x%h", rdata);

    #50;
    $stop;
  end

endmodule
