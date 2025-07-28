# VOCM REFERENCE
## REFERENCE GENERATION
- 2x1 kOhm 0603 footprints to generate 3.3 / 2 (= 1.65 V)
	- Ok, shouldn't be populated
- 1x1 kOhm 0603 footprint for current limiting
	- ok
- 1.5, 4.7 kOhm voltage dividers (0603)
	- (4.7) / (1.5+4.7) * 1.65 = 1.251 !!!!
	- VKA = Vref * (1+R1/R2) = 1.25 * (1+3.6/2.2) = 1.6489 (Cathode target voltage)

## VOCM REFERENCE BUFFERING
### Footprint
ok
### BUFFER (LMV321)
- Part number: ok
- MPN: ok

#### Structure (Buffer configuration)
- IN+: Voltage input
- IN-: Possibility to insert resistor to GND on negative side for defined load
- OUTPUT: 75 ohm Z,closed,out limiting to avoid instability in the face of capacitive load
- 0
- V+: 3.3 V with buffer amp, should be at 1.65 V so within range
- V-: gnd


# ADC Frontend
## ADC Connectors
### With magnetics
#### Input / Output pins
1, 4, 2:
- 4: center tap connection
- 1, 2: TD+ and TD-

3, 5, 6
- 5: center tap to ground
- 3, 6: test-points

7: NC

8: 
- AC ground connected to bob-smith termination with capacitor

9, 12
- Anodes
- 3.3 V connected to them

10, 11
- Kathodes
- Connected through a 470 ohm resistive divider to an FPGA pin
	- FPGA_LED high: no LED on
	- FPGA_LED low/floating: current to ground 
	- Forward voltage 2.2 V on average -> so 3.3-2.2 = 1.1 / (470*2) = 1 mA so very weak light

13, 14:
- Chassis: connected to ground (put 0 ohm resistor 0603) in case a capacitor would be required OK

#### Footprint check
OK

### Without Magnetics
#### Footprint
C708652
OK

- J1, J2 -> ok
- J3, J6
- J4, J5 -> ok
- J7, J8

Tied together in the right way

### Blocking capacitors
- 100 nF, X7R
	- Slight worries about the resonant freuency

- SRF = 1/(2*pi*sqrt(LC))
	- Assume L: 900 pH self-inductance
	- C = 100nF
- = 1/(2*pi*sqrt(900e-12 * 100e-9)) = 16.77 MHz

## ADC Switch
- Con = 26pF
- Ron = 0.37 ohms

### Connections
DIFFF1
- NC1: connected to IN+ of magnetics
- NO1: connected to IN+ of non-magnetics

DIFF2
- NC2: connected to IN- of magnetics
- NO2: connected to IN- of non-magnetics

ADC_IN12_SW
- Connected to FPGA
- Should be driven: 
	- input high: > 1.2V
	- input low: < 0.3 V

NC3: Connected to test-connectors
- IN3-4: driven by testpoint

- Low harmonic distortion
- Low crosstalk

### Footprint
- ok


## ADC Input Buffer
### Pins / Components
- Simulated completely in Tina-TI
	- Nice band-pass characteristic
	- Schematic simply copied
	- Added testpoints right after switch
- Decoupling: 10 uF, 100nF, 10nF OK
- PDn: should be high so NOT power down
- Vocm: should be set to 1.65 V with a 0.1 uF decoupling capacitor -> chose 220 nF OK (X7R)

### Footprint
- Layout: ok
- Pins: ok

## Testpoints U.FL.
- Component: OK
### Footprint
- Layout: ok
- Pin1: coax source (also in pin number)
- Pin2: shield (alson in pin number)

So OK!