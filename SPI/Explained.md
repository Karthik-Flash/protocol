SPI (Serial Peripheral Interface): SPI is a synchronous serial communication protocol used to transfer data
between a master and one or more slave devices.
//DESCRIPTION
- Full duplex, synchronous
- Master-slave with `MOSI`, `MISO`, `SCLK`, `CS`
- 12-bit transmission (customizable)
- LSB-first data send
- `done` signal indicates transaction completion

  
//SPI Simulation Example using Force Method
![spi waveform](https://github.com/user-attachments/assets/f2345047-0c5f-49f8-ba09-85ccbacf0486)


//SPI Simulation Example using Testbench
![spi tb waveform](https://github.com/user-attachments/assets/df06c9be-6dec-4207-9cad-9bf59fd026de)

//CODE EXPLAINED
->Module I/O Description

module spi (
input clk, start,
input [11:0] din,
output reg cs, mosi, done,
output sclk
);
Inputs:
clk : System clock (fast, e.g., 50-100 MHz)
start : Begins transmission when high
din : 12-bit data to transmit
Outputs:
cs : Active-low chip select for slave
mosi : Serial data output
done : Set high when transmission completes
sclk : Serial clock (used by slave)


->State Descriptions:

-idle :
Default state
cs = 1 , mosi = 0 , done = 0
Waits for start == 1

-start_tx :
Activates chip select ( cs = 0 )
Loads input data into temp
Moves to send state

-send :
if(bitcount <= 11)
mosi <= temp[bitcount];
Sends one bit per sclkt clock edge
Each bit is sent LSB first
After 12 bits, move to end_tx

-end_tx :
Sets cs = 1 to end transmission
Sets done = 1 for one sclk pulse
Returns to idle


//Summary

SPI requires precise synchronization via clock.
This Verilog module uses clk to generate a slower sclkt .
A simple FSM controls transmission on mosi .
sclk = sclkt exposes the divided clock for external use — essential for correct SPI behavior.
Data is transmitted LSB-first over 12 cycles, and the done flag signals end of transmission
