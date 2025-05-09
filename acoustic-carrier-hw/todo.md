# Ethernet
- Validate the use of 33 nF capacitors, check the effect of it
- Route the KSZ9031, base yourself on the LogicBone-example
	- Start with power

# Power
- Go through the LTSpice model for the buck-converters, check why there's a difference
- Add TVS current limiting

# USB
- Add USB PHY
- Add USB power supply to FPGA board (5 V)

# LED
- Add LED's to FPGA (check pins that can drive them)
- Add buttons to FPGA

# Connectors to power board
- Check whether it's best to put connectors above / below the board to connect to power board
- Foresee 4 PWM connectors to power board
- Check which connectors to place below FPGA board to connect to power-board.
