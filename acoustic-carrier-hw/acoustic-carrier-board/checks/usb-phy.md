# USB3300-EZK
## PINS
### Decoupling (1V8)
- OK: more decoupling capacitance than anywhere else
- REG_EN high

### Bias resistor
- 12 kOhm: OK

# TS3USBD30 switch


## Footprint (VSSOP)
- Pins: ok
- Footprint: ok

## Pins
Table 7-4

- Select: 
	- L -> D1, H -> D2
- ~OE: H: disconnect, L-> connect

# Schmitt Triggers
## Buffered schmitt trigger for switching

### Decoupling
- Added: ok
- Simulation:


### Footprints (SOT-23-5)
- LMV321: ok
- COS3201TR
	- Pins: Not OK  -> REDO symbol
		- 1: OUT
		- 2: GND
		- 3: IN+
		- 4: IN-
		- 5: Vcc
		- OK (modified)
	- Layout
		- ok
	

## Simulation
- Saturation when vin higher than 0.8 V (22k, 5.1k) 
- 0 Volt when vin lower than 0.5 V (in voltage divider: 51k, 5.1k)
	- OK

