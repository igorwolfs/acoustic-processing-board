# DC-DC Converters
- Add 1 x LM3478 (doesn't require level-shifting circuitry)
	- Boost converter: to bring a voltage of between 15-20 volts up to 40 V ()
- Add 1 x SEPIC converter for the level-shifting FET drivers
- Add 1 x SEPIC-converter for the 5 V power supply

## Goal
- We want to be able to adapt the driving voltage dynamically
	- The boost converter will need to drive the voltage to up to 40 volts
		- It however might have 9-10 volts connected
		- There should be a bypass from the boost converter VBAT directly to the inverted driving circuit as well
			- This way we can drive the piezo with voltages as low as 5 Vpp
	- The level shifter will need to continuously be at 10 volts.
		- It however might have 9-10 V connected
- We want to avoid working with variable resistors

### Boost converter (5-20 V -> 5-40 V)
- Input: between 5 and 20 volts
	- If < 10 volts: make sure you have bypass circuitry that allows you to directly drive the inverter from your source
	- If > 10 volts: make sure you have some-kind of soldering bridge or short that you can eliminate to force all current through the boost converter.
		- Add a spot for a feedback resistor slope compensation (in case D > 0.5)
- Output: between 5 V and 40 V
- Currents: max 10 amps RMS at 40 V


**Bypass** 
- Create a bypass for the boost converter (e.g.: simply 0-ohm high power resistor, or solderbridge) whenever you want to use pure battery voltage
- When you want to use a voltage unreachable by your power supply (e.g.: 40 V)
	- Make sure to use a boost converter, and set the input voltage between 10-20 Volts (to limit the stress on the passives)

### DC-DC Drivers (5-20 V -> 10 V) (Sepic)

- Input: between 5 and 20 volts
- Output: should ALWAYS be 10 Volts
- Currents: about 1-2 amps rms MAX

Goal is to have a level shifter which always shifts 10 V independent of the input voltage.
This way we can drive the piezo with lower and higher voltages, depending on what we want.

# Boost
