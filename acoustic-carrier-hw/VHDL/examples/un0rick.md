# Verilog code

## Clock generation
### ICE_CLK
Drives ref_clk
- Input for VGA_PLL
- Input for SYS_PLL
#### VGA_PLL
- Contains a pll_clock instantiation.
```v
SB_PLL40_CORE #(
    .DIVR          (4'b0000),
    .DIVF          (7'b0101111),
    .DIVQ          (3'b100),
    .FILTER_RANGE  (3'b100),
    .FEEDBACK_PATH ("SIMPLE")
) pll_ip (
    .LOCK         (lock),
    .RESETB       (1'b1),
    .BYPASS       (1'b0),
    .REFERENCECLK (ref_clk),
    .PLLOUTGLOBAL (vga_clk)
);
```

#### SYS_PLL
Contains a system PLL clock instantiation:

```v
SB_PLL40_2F_CORE #(
    .DIVR (4'b0000),
    .DIVF (7'b1010100),
    .DIVQ (3'b011),
    .FILTER_RANGE (3'b001),
    .FEEDBACK_PATH ("SIMPLE"),
    .PLLOUT_SELECT_PORTA ("GENCLK"),
    .PLLOUT_SELECT_PORTB ("GENCLK_HALF")
) pll_ip (
    .LOCK          (lock),
    .RESETB        (1'b1),
    .REFERENCECLK  (ref_clk),
    .PLLOUTGLOBALA (pulser_clk),
    .PLLOUTGLOBALB (sys_clk)
);
```

Here the PLL generates 2 different output clocks
- pulser_clk (128 MHz)
	- Used for the output pulse timing
- sys_clk (64 MHz)
		- Used for the system clock of the FPGA



## Acquisition module
Contains a state machine (fsm_state), indicating 


![](/un0rick/acq_fsm_0.svg)

### ADC
#### ADC_CLK
ADC input clock taken directly from the sysclock
#### adc_dout
Latched data ADC_D coming out of (ADC_DATA_W-1) wires
Going into acquisition module.

#### acq_start
Signals start of adc acquisition.
- Display
- Trigger (CSR)

### inice
- 3 random pins (IN3_ICE, IN2_ICE, IN1_ICE) that serve as an input

### acq_waddr
- Writes output address
- Determined combinatorially together with state machine
- Set synchronously inside synchronous loop


## Acquisition buffer

### Envelope calculation
```v
// acq_buff_env_next: unsigned magnitude of (sample - miscale) to build mean-absolute-value envelope
assign acq_buff_env_next = acq_wdata[ADC_DATA_W-1] ?  // Check the MSB
	acq_wdata[0+:9] : 						// if MSB=1 (sample ≥512),  abs (sample–512) = lower-9-bits
	511 - acq_wdata[0+:9]; //  else (sample <512), abs(sample–511) = 511 – lower-9-bits
always @(posedge sys_clk or posedge sys_rst) begin
    if (sys_rst)
        acq_buff_env <= '0;
    else if (acq_buff_fill_en) begin
        if (acq_buff_chunk_end)
            acq_buff_env <= {{7{1'b0}}, acq_buff_env_next};
        else
            acq_buff_env <= acq_buff_env + {{7{1'b0}}, acq_buff_env_next};
    end else
        acq_buff_env <= '0;
end
// resulting value is mean( abs (sample - midrange))
assign acq_buff_env_mean = acq_buff_env[6+:ACQ_ENV_DATA_W]; //6 = 5 (mean for 32 samples) + 1 (scale for plot)

```

### acq_buff_wdata
- Write mean envelope
- Write dac-gain
- write top-turn: 
	- 3 FPGA I/O's, which you can hook up a TTL-level signal to. (so you can stamp a state onto the samples)

### SB_RAM40_4K
Used to instsantiate 4 kbits data-ports with separate read and write port.
- Input and output 16 bits by default
- SB_RAM40_4K Positive-edged read clock, positive-edged write clock 

## CSR (control and status register)

Contains a whole bunch of separate registers controlled by this bus:
```v
input  wire [CSR_ADDR_W-1:0]     csr_addr,         // CSR address
input  wire                      csr_wen,          // CSR write enable
input  wire [CSR_DATA_W-1:0]     csr_wdata,        // CSR write data
input  wire                      csr_ren,          // CSR read enable
output reg                       csr_rvalid,       // CSR read data is valid
output reg  [CSR_DATA_W-1:0]     csr_rdata,        // CSR read data
```

Main writing to the CSR is done by SPI

## spi2csr
Contains an SPI peripheral.
SPI peripheral writes to the CSR module.
CSR module controls the FPGA.

## Flash
### FT2232HL-REEL connection
- Connects FLASH_SCLK/MOSI/MISO/CS/CDONE/RESET


### Direct connection to ICE40
- connects through FLASH_SCLK/MOSI/CS/MISO
- However it is uncommented in the top-file

## RAMCTL
### ramctl buses
```v
// RAM controller bus muxes
assign ramctl_wen   = ramf_active ? ramf_wen   : acq_wen;
assign ramctl_wdata = ramf_active ? ramf_wdata : acq_wdata;
assign ramctl_addr  = ramf_active ? ramf_addr  : ramctl_ren ? ramctl_raddr : acq_waddr;

ramctl #(
    .DATA_W (RAM_DATA_W), // RAM data width
    .ADDR_W (RAM_ADDR_W)  // RAM address width
) ramctl (
    // System
    .clk         (sys_clk),       // System clock
    .rst         (sys_rst),       // System reset
    // External async ram interface
    .ram_addr    (ram_addr),      // External RAM address
    .ram_data_i  (ram_data_i),    // External RAM data input
    .ram_data_o  (ram_data_o),    // External RAM data output
    .ram_data_oe (ram_data_oe),   // External RAM data output enable
    .ram_we_n    (ram_we_n),      // External RAM write enable (active low)
    // Internal fpga interface
    .addr        (ramctl_addr),   // RAM controller address
    .wdata       (ramctl_wdata),  // RAM controller write data
    .wen         (ramctl_wen),    // RAM controller write enable
    .rdata       (ramctl_rdata),  // RAM controller read data
    .rvalid      (ramctl_rvalid), // RAM controller read data is valid
    .ren         (ramctl_ren_muxed) // RAM controller read enable
);
```
- External RAM is written to on sysclk (so at 64 MHz)

## Debouncer
Used to debounce 
- triggers
- buttons

# Notes
## Questions
### How many clock outputs can a single PLL generate?
For the ICE40
- globally routed: uses specialized fabric / buffer trees (low skew, big fanout, phase alignment / deskew circuitry)
- fabric routed: Use the same fabric as any other signals (higher jitter, skew, low fanout)

## Dual repo
For some reason there are 2 repos, one with VHDL and one with verilog.
They seem to be 2 separate projects used independently for the ultrasound hardware.