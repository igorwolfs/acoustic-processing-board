# Requirements
- Must have a 1Gbs speed option
- Must have an internal PLL outputting the relevant clock
- Must have an RGMII or GMII interface (SGMII is barely supported for open ethernet IP's)


# PHY choice

## KSZ9031RNX (CHOSEN)
- Very commonly used in opensource projects, schematics available
	- e.g.: in logicbone
- Way more expensive (3 dollars instead of 1.5)

### Digital interface
RGMII timing interface support (3.3, 2.5 and 1.8 V)

### Power
- Single 3.3 V LDO supply

### Clock
- 125 MHz PLL clock output

### Digital interface
- GMII interface

### PHY interface
- On chip termination resistors


## Ethernet Chip: RTL8211F-CG
- Biggest issue: not many example schematics, configuration and documentation out there.
- Dirt-cheap (1.2 dollars)

### Digital Interface
Has 10/100/1000M Ethernet.
Has an RGMII-interface.


### Pins
#### RGMII (FPGA) interface
- 4 TX pins
- TXC (TX clock signal)
	- 125, 25 or 2.5 MHz
- TXCTL (transmit control signal)
- 4 RX pins
- RXC signal
	- 125, 25 or 2.5 MHz
- RXCTL (receive control signal)
- XTAL

#### PHY interface
- 4 base pairs

#### Clock
- XTAL_IN / XTAL_OUT:
	- 25 MHz crystal input/output
- CLKOUT:
	- 125/25 MHz: reference clock generated from internal PLL

## DP83867S
- More expensive (2.65 dollars)
- Multiple examples available (https://github.com/kazkojima/dp83867s-sgmii-board), also with the ecp5u and litex



# Example
## Logicbone
- Has ethernet, DDR3 and other high-speed signals
	- Uses the 

# Bit-Brick K1
Uses the RTL