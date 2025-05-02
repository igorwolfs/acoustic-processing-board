# un0rick
https://github.com/kelu124/echomods
## What is it
Uses a combination of hardware, firmware, VHDL and software that was used to experiments with various opensource ultrasound modules.
Note that this was mostly used for beamforming, not for simple ultrasound ToF measurements.

It uses the un0rick-board (https://un0rick.cc/) which contains the 
- ADC
- FPGA (Lattice ICE40HX4K for DSP, acquisiton and PWM driving)
- 8 MBit SRAM
- 8 MBit SPI Flash
- FT2232H
- USB connector (power supply + programmation of SPI-flash)
- RPI 20x2 Header
- TGC (Analog time gain compensation using a variable gain amplifier controlled by a DAC)
	- Which allows for selective amplification of weaker signals.
	- This way weaker signals coming from deeper in the tissue are amplified to look brighter
- RPI / USB connection

### Driving circuit
- HV7361 GA is the pulse generator used here
	- It supplies a max of +-2.5 amps
	- It supplies max pulses of 100 V
	- D P/N 1/2 are the outputs for the pulse supply



# lit3rick
## What is it
### Processing / Digital logic
- Lattice UP5K, with onboard RAM
- Onboard flash
- I2S connections

#### FPGA connections
**ADC**
- Data lins (10)
- DCLK
- ADC_CLK (apparently the ADC requires 2 clocks? One for oversamling?)


**MISC**
- Leds and buttons
	- ICE_CS
- RCLK (putting device in standby)

**I2S interface**
- PCM_DIN, PCM_FS, PCM_CLK

**Flash SPI interface**
- F_SCLK, F_MOSE, F_MISO

**DAC SPI Interface**
- DAC MOSI
- DAC_SCLK

**USELESS**
- SCL
- EA_CLK
- HV_EN

- SPI-flash connection on pins
- DAC

### Pulse generation
- HV7361GA-G up to +- 100 V
- Question:
	- Do they actually have band-pass filter for the supply?
		- 

### AD8331
Variable gain amplifier
- Voltage selection through the DAC (MCP4812) for adaptive gain.

### ADC
- 12 bits 64 MSPS


# pic0rick
## What is it
## Analog front-end board
### Variable gain amplifier
- DAC to control the variable gain amplifier.


### ADC
ADC10065CIMT_NOPB
- 65 MHz
- Passes data onto the RPI pico


## MUX board
- Boost converter (5 V)
- Pins

### MAX14866UTM+T
- High voltage analog switch that requires only a 5 V supply.
- Switches RX and TX
- INSANELY EXPENSIVE (like 52 dollars each)
- Driven by RPI probably

### Connectors
AMPHENOL_132357-11 
- Which is a simple SMA connector
- One used for RX and one for TX
- Up to 1000 VRMS
I normally wouldn't send more than 100 watt through an SMA connector, which is normally the goal. So I don't really understand how they used a single SMA to drive their piezo-element.

## Pulser-board
- There's only a single side of the piezo being driven, not both. So it's not a true differential drive
### MD1213K6-G
He has 2 of those, for some reason one with a "Pulse" input and one with a "Damp"-input.


# echOpen
## What is it
An opensource project to make ultrasound accessible.
The hardware files and electronics can be found in the following repo: https://github.com/echopen/PRJ-medtec_kit.git.

- It uses a stepper motor to shift the location of the piezo-electric. So it's basically a mechanical sonar array, not a phased-array.
- It contains various analog and digital PCB's, for motor driving as well as analog and digital signal processing.



# NOTES
## DAC + VGA vs digital amplification
A lot of these boards have a separate DAC controlling the VGA for variable gain amplification. 

Think about doing a similar thing if you can, or maybe have a separate pair of pins available for controlling a DAC on the analog board from the FPGA.
