# Pin Selection

- USB0..7
- CLK: E13
- STP: E12
- DTR: E11
- NXT: D13
- RST: C13

## CLK pin
- Make sure to route the clock pin into the relevant clock input.



# Impedance Matching / Routing

- 60 MHz bus
- Clock should probably be connected to PCLKT1_0
	- Similarly in Trellisboard
- Clock is connected to ULC_GPLL1C_IN for EPC5UM5G_86

## Impedance / Trace control

- ULC_GPLL1C_IN: USB.REFCLK: Takes in a 60 MHz signal.


### Impedance control
- 50-60 ohm controlled impedance
- Length limitation to 3 inches
	- 76,2 mm

### Signal length limits
- All signals should be within 0.5 inches of CLKOUT
	- 0,5 inches = 12.7 mm


## Extra resistors
- Place 0 ohm termination resistor next to CLK

## Rise / Fall times

## Sources:
- https://ww1.microchip.com/downloads/en/AppNotes/en562704.pdf
