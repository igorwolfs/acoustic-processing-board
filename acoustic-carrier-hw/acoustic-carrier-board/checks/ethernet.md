# Ethernet PHY
## KSZ9031
### Footprint
- Pins: ok
- pad dimensions: ok


### Pin Connections
#### Power

AVDDH
- 3.3 V OK
- 1 uF, 10 uF, 0.1x2 uF decoupling
- 100 MHz ferrite
- 10 nF added

DVDDH:
- 3.3 V OK
- 0.1x2 uF
- 1 uF
- 10 uF- 10 nF added

DVDDL: 
- 1.2 V OK
- 10 uF, 0.1 x 5 uF
- 10 nF x 2 added

AVDDL:
- 1.2 V OK
- 2x0.1 uF
- 10 uF
- 10 nFx2 added
- ferrite

AVDD_PLL:
- 1.2 V OK
- 10 uF
- 0.1 uF
- ferrite 

So in general
- At leas 0.1 uF per pin
- 10 uF bulk for pin group
- Ferrite for analog voltages

**Ferrite check**
- 0805 Ferrite inductor
- 100 ohms at 100 MHz (so seems ok)
- Current probably > 100 mA

#### Crystal resonator
- 25 MHz ok
- 2x22 pF capacitance connected ok
- Pad: SMD3225-4P
	- Pin: 4, 2 GND
	- Pin 1, 3: connections OK
- Pad: sizes ok


#### Differential pairs connection
- Connected to the right labels
- Should be length-matched?

- Figure 12-1
