# 


# Board Mounting location
For the correct board mounting position, it's important for it to be
- Mechanically solid
- good EMI-wise

Since most of the power will probably be routed on the top layer, it seems better to
- Mount the power-board on top of the processing board
	- to avoid EMI issues.
- Mount the power-board sideways with the processing board
	- Clear visibility of the LED's and buttons on both processing and power-board


# Electrical considerations
## Major Power and ground connectionss
- There needs to be a good connection to ground right next to the power connection (minimal EMI issues)

## PWM connections
- We could make the PWM signal differential, which would eliminate the need for a return path.
	- However this would imply loads of analog circuitry

Consider using the 
- C7470109 (2x6 pins, 1.27 mm)

# Board mounting example repos
- PicoSat: Assembly of interconnected PCBs: https://github.com/Kmshanley/PicoSat-Initiative.git