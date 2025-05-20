(ECP5 and ECP5-5G sysCLOCK PLL/DLL Design and User Guide)
# Available clocks
- 125 MHz (Generated through ethernet-PHY), injected into PLL
- Internal on-chip CMOS oscillator
	- Default: 2.4 MHz, can be (4.8, 9.7, 19.4, 38.8, 62 MHz) after boot

# Required clocks
## DDR3L
Doesn't really "Require" a clock, but the recommended speed grade it's tested for is 1066, so 533 MHz toggling CK CK# pair.

## ADC
- The ADC's max sampling rate is at 35 MHz, so check for an oscillator that can provide something around that number (like 17 MHz)

## UART
- The UART baud rates are multiples of 115200, check if you can get something that communicates at those speeds



# Lattice Clock Specs
- maximum PLL frequency for the lattice PLL is 8-400 MHz
	- So anything higher or lower isn't generateable.
- VCO frequency is between 400 MHz-800 MHz
	- But this is divided down and apssed to the CLKOP / CLKOS (PLL output dividers)
	- This divided VCO signal can be routed.
