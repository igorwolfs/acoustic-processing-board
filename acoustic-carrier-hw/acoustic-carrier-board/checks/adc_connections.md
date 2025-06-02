# ADC
## Details
- Footprint ssop: ok
- LPN: ok
- MPN: ok

## Connections
### Power
#### VDDA
- Conneced to AVDD
- 10 uF decoupling OK (x5r, 0603)
- 0.1 uF decoupling, 0402, X7R ok
- Ferrite: 100 ohm @ 100 MHz (0805), ok
	- Max current: 800 mA, so more than ok
	- 0.15 ohm DCR

#### VDD
- 10 uF, 0.1 uF decoupling ok

### AIN+, AIN-
- ADC_AIN+: connected to AIN
- ADC_AIN-: connected to ADC_REFTS with 0 ohm resistor (0603)
	- ADC_REFTS and ADC_REFBS are shorted for input 2
	- Done with bridged jumper
	- Biased to AVDD/2 (in analog_frontend)

### Mode
- Set to AVDD/2 (done)
	- Possibility to set to VDDA and GND

### VREF, REFSENSE
- CURRENTLY Shorted
	- 1 V input span

- CAN BE disconnected 
	- REFSENSE to GND
	- VREF disconnected

- VREF has 0.1 uF and 1 uF capacitors
	- As required for 2 and 1 V reference mode

#### ADC_REFTF, ADC_REFBF
Check figure 2cREFBF
- 10 uF, 0.1 uF between REFTF and REFBF
- 0.1 uF between each line and ground
OK

#### TRISTATE, STBDY, CLAMP, CLAMPIN
STBY:
- GND: normal operation

TRISTATE:
- GND: normal operation

CLAMP:
- Low: no clamp mode -> so clampin here probably doesn't matter
- Grounded in example

CLAMPIN: 
- Clamp voltage setting
- Disconnected in example schematic (x3)
- Grounded in example schematic (x1)
- Just to be sure add 0 ohm jumper possibility to ground

#### OTR, Data, CLK
- Should all be connected to FPGA-bank: OK

# SIGNAL CONNECTOR
- Signals are only mentioned once
- Named them SIG_<signal_name>
- Reroute later

# FPGA BANK
- VCCIO: core 3.3 V, just like data signals
- FPGA_IN12_SW -> changed to ADC_IN12_SW
- FPGA_ADC_LED->FPGA_LED
