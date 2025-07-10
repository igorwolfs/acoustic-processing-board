# FPGA Config Bank
CHECK: ECP5 and ECP5-5G sysCONFIG User Guide

## JTAG
- JTAG_TMS: 3.3
	- (weak pull-up OK)
- JTAG_TCK: gnd
	- An external pull-down resistor of 4.7 kΩ is recommended to avoid inadvertently clocking
the TAP controller as power is applied to the ECP5 and ECP5-5G devices. OK
- JTAG_TDI: 3.3 
	- (weak pull-up OK)
- JTAG_TDO: 3.3
	- (weak pull-up OK)
- FPGA_CFG2: GND (pull down)
- FPGA_CFG1: 3.3
- FPGA_CFG0: gnd
	- SPI: [2:0] = 010 -> Master QSPI configuration OK


## QSPI
NOTE: 
- normally SPI is open-drain
- However in examples pull-ups of the pins are observed


- MSPI_CSPPin: 3.3V
	- Pull-up recommended (sysconfig manual)
	- CSSPIN should have 4.7 kΩ pull-up on-board resistor for MSPI.
- MSPI_CSPPin2: 3.3V
	- Pull-up recommended (sysconfig manual)
- MSPI_MCLK: 3.3 V
	- 1 kOhm pull-up recommended (sysconfig manual)
- MSPI_D0..3: 3.3 V
	- 10 kOhm Pull-up recommended (sysconfig manual)
	- MOSI and MISO should have 10 kΩ pull-up resistor on-board for MSPI.
	- IO[3:2] should have 10 kΩ pull-up resistor on-board for QUAD MSPI.

OK

- CSn / SN: bi-directional pin (Slave SPI / Parallel mode)
	- CSN: active low input in parallel mode only
	- SN: slave SPI mode - used for low chip select input
		- Pull high externally (weak internal pull-up not that strong)
		- DONE: pulled-up

- CS1N: active-low input pin
	- Parallel mode (unused)

- WRITEN: (only in parallel mode? -> Check this one against other schematics)
	- direction of the data-pins
		- LOW: clock into
		- HIGH: clock out of

- D1: MISO
- D[7:0]: IO-pins
- IO[3:0]: Quad-SPI
- PERSISTENT: Internal control bit register

## System pins
- DONE: pull-up
- INITn: pull-up
- RESET: pull-up

Mentioned in table 4.5 -> OK

# Flash
## Size:
128 MBit flash = 16 MByte flash x 2

## Footprint
- SOIC-8-208mil
- Pins ok

## Pin Conections
- Look exactly as supposed to
- Check example
	- Orange Crab: ok
	- Cynthion: ok