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


# Delays / Setup / Hold times
## t_CO: clock-to-output delay
The time it takes for a valid output signal to appear at an output pin AFTER a clock signal transition on an input pin.
SO: external pin-to-pin delay.

e.g.: time between clock edge triggering register and the output signal becoming stable.

### Without PLL / Primary clock
- 5.4 ns - 6.8 ns

### With PLL
- 3.5 ns - 4.1 ns

## t_SU: Clock-to-Data-setup time

Minimum time interval BEFORE the clock-edge during which the input data must be stable to be reliably captured.

### PIO input register
#### Without PLL / Primary clock
0 ns

#### With PLL
0.7 ns - 0.85 ns (so PLL delay I guess)


### PIO input register with data input delay
#### Without PLL / Primary Clock
1.2 ns - 1.46 ns

#### With PLL
1.6 ns - 1.95 ns

## t_H: Clock-to-Data-hold time

Minimum time interval AFTER the active clock edge the input data must be stable to be captured by a flip-flop / sequential element.

### Without Data Input Delay
#### Without PLL / Primary clock
2.7 ns - 3.3 ns

#### With PLL
0 ns

### With Data Input Delay


#### Without PLL / Parimary Clock
0 ns

#### With PLL 
0 ns

## fmax_IO
Maximum clock frequency of I/O and PFU register
- 400 - 312 MHz
