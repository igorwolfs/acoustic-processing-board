# High-Speed Digital
## USB 
### Power delivery (FUSB302BMPX)

Contains the PD-control part, communicates over I2C with the FPGA and passes on information about the power capabilites of the host.

### Switch (PI3USB102G)
Controls whether the upper or lower part should be switched to the MCU.

### Controller USB3343-CP
- USB2.0
- So up to 460 MHz (similar as usb3303 used by me)

Routing and stackup can be done akin to this device.

## HyperRam (W956D8MBYA)

### Pins
- DQ0..7
- Differential clock signal

### Frequency
- Clock speed max 200 MHz	

# Power
## Voltage levels
- 5 V
- 2V5
- 1V1
- 1V8

## Power monitoring (PAC1951)

VBUS and VSENSE sampling, through 16-bit ADC, along a range of 0 - 32 V.


## Sense resistors
- Present everywhere, about 0.02 ohms.

## Signalling
- Power-good signal
	- Indicates that the power is ok.