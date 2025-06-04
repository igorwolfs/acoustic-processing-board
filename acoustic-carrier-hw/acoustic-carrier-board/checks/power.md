# BUCK CONVERTERS
## Universal IC's / Inductors

### Buck converter IC
#### Footprint (Package: sot-23-5)

- Pins: OK
- Footprint: SOT23-5
	- Looks great, pin connections are ok here as well

### Inductor
- 2.2 uH inductor
- Saturation / Inductance: ok

#### Footprint
- SMD,4x4mm
Dimenisons:

- NR4018S 4.0±0.2 4.0±0.2 1.8 Max. 3.3±0.2 0.95±0.2 2.1±0.2 1.9 1.1 3.7 
	- Copied from online: ok
- Input appropriately

### 4.7 uF input capacitor
- Footprint OK
- voltage oK


## Ethernet Supply (1.2 V)
Tina-TI simulation: looks great
- Total of 21 uF smoothing capacitor at buck converter
- Further decoupling at ethernet PHY

## Auxiliary supply
### Output bulk / smoothening
- 31 uF (2.5V)

### Further pin decoupling
- 10 uF bulk close to pins
- 2x01uF for HF decoupling

### Additional AUX decoupling
- 0.1 uF x 2

## DDR3L supply (1.35 V)
### Output smoothening
- 31 uF decoupling at output
### Further decoupling
- 4 x 0.1 uF
- 2x10 uF bulk closer to pins

### Additional DDR3 PHY + BANK decoupling and bulk
- 2x10uF
- 3x22uF
- 4x0.1uF
- 1uF

## Reference voltage generation
### Resistive divider option (1k)
- Used by butterstick
- Loads of decoupling next to it.
- 1k, 1k
	- So current flowing is [1.35 / 2] mA = 0.675 mA

### Reference IC TPS51200DRC
- Used by Trellisboard

-> Use this instead of the resistive divider, it provides a stable output for DDR3L and its reference.

### DDR3 examples
- Butterstick
- Logicbone
- Trellisboard
- ulx3s
- lit3rck
- pic0rick
- multi-channel-oscilloscope
- VNA
