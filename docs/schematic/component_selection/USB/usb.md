# CH340N Connector
## Pins
### Pin 3, Vcc
- Connect both to 3.3 V (make sure logic levels and everything is at 3.3 V)
- At 100 nF capacitance per pin (decoupling)

### TX, RX
- Connect 2 series 0-ohm resistors in case of too high current.

#### RX
- Must be pulled up externally to 10 kOhm if not done internally

## Diodes
To avoid current flow when USB device booted but FPGA not yet
- Connect TXD diode between RXd -> TXD
- Connect diode between Boot -> RTS
- Put some kind-of swith in between RXD->TXD which only allows current flow when Vdd on the MCU is high
	- Alternative: simply use 


### High-Low voltages
in 3.3 V mode
- VIH: 1.9 - Vcc
- VIL: 0 - 0.8 V
- VOL: 0 - 0.5 V
- VOH: Vcc - 0.6 V - Vcc

vds

# USB3300-EZK
