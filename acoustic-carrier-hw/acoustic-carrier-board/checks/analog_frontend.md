# Checking Method
1. Check the footprint, compare the distances and the pins
2. Given the pins are correct, check the symbol connections against the datasheet
3. OK

# Signal Connector
## Footprint
- https://jlcpcb.com/parts/componentSearch?searchTxt=C2897428

- Footprint: horizontal 8x2
	- OK -> Maybe lines not completely ok

## Symbol
OK

# ADC Frontend

## RJ45 with magnetics
### Footprint
- rj45:RJ45-TH_HR913550A
ok

## LED
- Resistive divider at kathode
- 3.3 V at anode
- ADC_LED_i low -> led on (current 1.2 / 470 = 2.6 mA)
- ADC_LED_I high -> led off

## AC ground
OK
## Input connections
- AIN1, REFTS: differential pairs
- Center tap: vdd/2 OK

## Resistors connecting
- RJ45 regular connector
- 

## TODO
- Add a low-pass filter at the input
	- Add a common mode choke like this one in series: https://jlcpcb.com/parts/2nd/Filters/Common_Mode_Filters_3124
	- Add a capacitor in parallel
	- Make sure to check for resonances.