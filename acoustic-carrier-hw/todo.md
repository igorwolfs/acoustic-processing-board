# LED
- Add LED's to FPGA (check pins that can drive them)
- Add buttons to FPGA

# Oscillator
- Check which other oscillators we would need
	- We have 125 MHz from the ethernet peripheral
- We need 35 MHz for the ADC
- We need 

# Connectors to power board
- Check whether it's best to put connectors above / below the board to connect to power board
- Foresee 4 PWM connectors to power board
- Check which connectors to place below FPGA board to connect to power-board.

# DDR3
- Add symbol
- Add footprint

# FPGA
- Issues with 
	- BGA256

- IC1 has in the units E and G unplaced
	- Directional pins
	- Current supply pins
	- Units

## TODO
- Switch ethernet and usb
- Put power in between ethernet and USB
- Make sure there's enough filtering, and have 4 local power planes sufficiently close to the power-circuitry (3.3V, AUX, ETH, DDR3)
- The 3V3 power plane should propagate all the way, and should have big vias around it on the analog side
- Probably the same should happen surrounding the power supply circuitry
- USB and power connector should both be together on the side of the USB and power supply


## ON SUB-BOARDS (driver, receiver)
- Make a single board that can both be driven through one high-power path
	- There is a switch that can take part of the sent signal that goes into the piezo (maybe with some coupling)
		- Sends it back to the ADC
	- There is a switch that can send the received signal on 