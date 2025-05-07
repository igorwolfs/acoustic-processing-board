# ADC Data Path
## ADC Module
- ADC Data is read from ADC_DATA

Then it is combined into this bus:
```v
assign adc_wr_data = {TOP_T2,TOP_T1,HV_EN,HILO,ADC_DATA,2'd0};
```

And passed into the SPRAM256KA module.

### SPRAM256KA

A primitive that can be used to instantiate a blockram element: http://pages.hmc.edu/brake/class/e155/fa23/assets/doc/FPGA-TN-02022-1-3-iCE40-SPRAM-Usage-Guide.pdf

```v
  SB_SPRAM256KA ram(
 		.DATAOUT(adc_rd_data),
 		.ADDRESS(ADDRESS),
 		.DATAIN(adc_wr_data),
 		.MASKWREN(4'b1111),
 		.WREN(adc_wr_en),
 		.CHIPSELECT(1'b1),
 		.CLOCK(DCLK),
 		.STANDBY(1'b0),
 		.SLEEP(1'b0),
 		.POWEROFF(1'b1)
  );
```


- adc_wr_addr
	- Increments on every write
	- Stops writing when disabled (wr_en -> set to 0)

### SB_RGBA_DRV

```v
  //Driving output LED for status monitering
  //Red  -> Capturing Data or Busy for SPI_Read
  //Green-> READY for Capture or Read
  //Blue -> Blinks during DAC Configuration
  SB_RGBA_DRV #(
             .CURRENT_MODE ("0b0"),
             .RGB0_CURRENT ("0b111111"),
             .RGB1_CURRENT ("0b111111"),
             .RGB2_CURRENT ("0b111111")
  ) RGB_driver (
             .CURREN   (1'b1),       // I
             .RGBLEDEN (1'b1),       // I
             .RGB0PWM  (~adc_wr_en), // I
             .RGB1PWM  (adc_wr_en),  // I
             .RGB2PWM  (1'b1),  // I
             .RGB2     (RGB[2]),      // O
             .RGB1     (RGB[1]),     // O
             .RGB0     (RGB[0])        // O
  );
```
https://hackage.haskell.org/package/ice40-prim-0.3.1.4/docs/Ice40-Rgb.html

Shows whether the adc write is currently enabled or not.
Specific hardware primitive to enable the LED driving fabric in the FPGA.

## Controller Module 

### ADC output clock 
- ADC_CLK (pin 37)

Clock is instantiated using:
```v
defparam OSCInst0.CLKHF_DIV = "0b00";  // 48MHz internal Clock, no divider

SB_HFOSC OSCInst0 ( .CLKHFEN(1'b1), .CLKHFPU(1'b1),.CLKHF(ADC_CLK))
```

#### Other options
- Rerouting an external clock through the FPGA fabric
```v
reg clk_div2;
always @(posedge ext_clk or posedge rst) begin
  if (rst)     clk_div2 <= 0;
  else         clk_div2 <= ~clk_div2;
end

// then route clk_div2 through a global buffer and out to your ADC
```

- Output an internal clock
	- However: this might lead to jitter when going to high frequencies.

### adc data handling
#### adc_read_addr
- Drives this signal after the amount of samples is completely full.
#### adc_rd_data_in
reads the data in and passes it to the SPI peripheral.

## SPI
### to_spi_out
- Passes adc data through this bus to PSI

### SPI_Interface module

Very rudimentary SPI interface

### to_spi_in
Inputs data gotten from SRAM straight to SPI.


## Pulse module

```v
 Pulse_Generator_Module pulse_generator (
  .phv_out(high_voltage_pulse),
  .pnhv_out(low_voltage_pulse),
  .pdamp_out(damping_pulse),
  .dclk_in(reset_signal12),
  .adc_wr_addr_in(adc_write_addr)
 );
```

A very simple module that generates high voltage, low voltage and damped pulse
- PHV   <= (adc_wr_addr>=24 && adc_wr_addr<30 ) ? 1'b1 : 1'b0;
- PnHV  <= (adc_wr_addr>=36 && adc_wr_addr<42 ) ? 1'b1 : 1'b0;
- Pdamp <= (adc_wr_addr>=48 && adc_wr_addr<96 ) ? 1'b1 : 1'b0;

with the adc_wr_addr incrementing with every write. (so every adc clock cycle)

The output goes to:
```v
 output high_voltage_pulse,
 output low_voltage_pulse,
 output damping_pulse,
```

## Communication over flash (W25X10CLSNIG)
Connected with 
- F_CS, F_MISO, F_SCLK, F_MOSI
- Pins 14 - 17 (except for 16, CS (slave select probably?))
- Also connected with outside pin connector

## Temperature Sensor
- SCL, SDA in schematic
- Not showing up in verilog?


# Notes
Verilog code was generated using project icestorm.
Check TerosHDL-project for diagrams