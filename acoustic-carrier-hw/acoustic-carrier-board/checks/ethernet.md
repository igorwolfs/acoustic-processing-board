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

#### LED's
- Look ok

#### Differential pairs connection
- Connected to the right labels
- Should be length-matched?

- Figure 12-1
	- Connections to HR91130A look good


#### Ground / ISET
- VSS, PAD_GND, ISET:
	- ISET: 12.1 kOhm to ground -> using a 12 kOhm
	- Vss: digital ground is ok

## HR911130A
### Footprint
- Pin numbers vs footprint: ok
- dimensions: ok

### Connections
- P1: center tap, should it be grounded with a cap or simply grounded tout-court?
	- I think completely grounded, I don't understand why you wouldn't ground this pin.
	- No it should be grounded with a cap, DC is already set through the differential pairs
	- DATASHEET (FIGURE 12-1: TYPICAL GIGABIT MAGNETIC INTERFACE CIRCUIT)
		- 0.1 uF from center-tap to signal-gnd

#### MDC, MDIO
- MDIO: 
	- requires an external pull-up: ok
	- Not done in logicbone but mentioned as issue
- MDCLK
	- Nothing mentioned -> simply connected
	- Same as in logicbone

#### ETH_TX/RXCTL, TX/RXD, TX/RX_CLK
- No pull-ups required directly connected
- RXD0..RXD3 also have MODE-pins
	- These pins are latched on boot to get the configuration registers
	- Should be pulled HIGH all: advertise all capabilities (10 MHz, 100 MHz, 1 GHz)
	- Logicbone: same
	- Trellis: same
- RX_DV, CLK125_EN
	- CLK125_EN latched to enable clock on power-on
	- HIGH: enables clock on power-up
	- Logicbone: same
- ETH_RXCLK:
	- sets PHY address: Set to 000
	- So pull this pin down.
	- Same in trellis

#### LED0, LED1, ETH_RXCLK
- Pull down configuration for both LED0, LED1, ETH_RXCLK set to 0
	- Like in logicbone also RCLK, LED_L, LED_R are pulled down to 0 kOhm.

#### ETH_INT
- Pulled up: enable active-low and power management functions
	- Same in trellis

#### ETH_REFCLK
- Clock output 125 MHz
	- Should be connected to clock input pin
	- Connected to GR_PCLK: not sure if this is the best option -> check later with rerouting
- Latched as LED_MODE
	- pull-up: single led mode
	- pull-down: dual led-mode
- Pulled-down!
	- Left in the middle for logicbone, connected to GPLL1C

#### NRESET
- Active low
- Pulled up with debouncing cap
- Suggestion has an additional diode between RESETn and FPGA
	- Direct connection however in trellis-board so added 0 ohm resistor to be sure.