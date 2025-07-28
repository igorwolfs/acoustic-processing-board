# Specs (LFE5U-25F-6BG256C)
(in datasheet as LFE5U-25F)
## LUTs

## Memory
### Distributed RAM
Typically used for small memory in-between (like a flip-flop to synchronize data). Really flexible and low-latency.
HOWEVER: requires lots of LUT's


### Embedded (Block) RAM
Hardwired memory of 18 kb each.
- Amount: 56 blocks of 18 kb


## Clocks
Requirements for edge-clocks
- 35 MHz clock for ADC 
- DDR clock supply
- Ethernet clock supply


### PLL / DLL
- 2 DLL's, 2 PLL's

#### PLL

For EACH PLL:
- 2 INPUTs: (with possible dynamic selection)
	- External lock
	- Internal routing
- 4 OUTPUTs with their own dividers:
	- CLKOP
	- CLKOS, CLKOS2,CLKOS3 with programmable phase-shift possible compares to CLKOP.

#### DLL
- 24 k LUTs
- 56 sysmem block
- 108 kb embedded memory
- 194 kb distributed RAM

### Clock distribution networks
- Primary clock (PCLK)
- Edge clock (ECLK)

### Edge-clocks
- Clock input pin (PCLK)
- PLL outputs (CLKOP, CLKOS)

### Dividers
- 2 clock dividers
- % 2 and % 3.5 mode

## IO's
- INput register block

# TODO
- Check LED output pins, select them for output led driving
- Check DDR2/3, LPDDR2/3 output pins
- Check SPI output pins
- Check SPI boot flash interface (even Dual-boot images supported!)
- Check output pins for an ethernet connection
	- Simply allows you to use the same connection twice, at high speed.
	- Check if you can simply use caps instead of magnetics, so you can use the same connector


## Good example projects
### icesugar-pro
- FPGA used: LFE5U-25F-6BG256C
- Verilog
	- Linux SoC instantiation
	- UART
	- HDMI example
	- Blinky
- SDRAM
- SPI flash
- 25 MHz Crystal
- Flashing interface (iCELink-interface based on APM32F1)

### anice
- FPGA used: ECP5U_12_CABGA256
- 256 MiB RAM
- 128 MiB flash
- HDMI
- (prototyping phase?)

#### Clock used
- No external clock?


### basic-ecp5-pcb
- FPGA used: LFE5U-12F-6BG256C

#### Oscillator
- 16 MHz input

### ECP5-mini
- FPGA used: ECP5U_12_CABGA256

#### Clock used
- 16 MHz

#### RAM
Hyperram S27KL0641

### Orangecrab Hardware
- Lattice ECP5-25F

#### DDR RAM
- 128 MBytes DDR memory (MT41K64M16TW-107_J-TR)
- 1.07 ns cycle time
- Differential clocks


#### USB-C connection

#### Flash
- 128 MBit QSPI flash W25Q128JV
- MicroSD socket

#### Clock
- 48 MHz onboard oscillator
- Connected to pin PCLKT1_0
