# High-Speed digital
## SDR (Single-data read) SDRAM
### Datasheet
- https://datasheet.octopart.com/MT48LC16M16A2TG-7E-IT:D-Micron-datasheet-7627877.pdf
- Out of production

### Data transmission
- Clock speed: 167 MHz .. 100 MHz
- Only read / write once every clock cycle
	- Internal clock source == external one.
- Doesn't require length matching, since toggling speeds are simply too low to matter.


### Voltage
- Only needs 3.3 V

### Pins
#### Address
- 12 address pins, single clock, some setting pins

#### Data pins
Seems to have a single DQ strobe-signal for each DQ-group, not a differential one like DDR.

- 16 data-pins
- DQ-strobe for lower bits
- DQ-strobe for higher bits

The DQ-strobes are meant for writes, to allow byte-level write enabling. They are not for data sampling synchronization.

# Analog
## MAX11120 ADC
### Pins
- 7 inputs

### Frequency
- Max: 1.5 MHz

## JACK_TRS_6PINS

Audio Jack

### Pins
Connected to 5 pins each resistors 1k1, 549, 279, 130

- Audio-V (probably voltage reference or ground)
- Audio-L (Audio left)
- Audio-R (Audio right)

The point is probably to have some kind-of DAC-system, so it is meant to be low-speed analog.

# RF
## WiFi
WiFi model together with antenna.
All together contained on a 


# Voltages
- 1.1 V
- 2.5 V
- 3.3 V