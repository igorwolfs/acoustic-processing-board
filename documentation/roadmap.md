# Research
## Physics
### Wave mechanics
&#9745; Make sure you understand the terms in the wave equation
- &#9745;  The different types of waves (longitudinal vs transverse)
- &#9745;  Difference between elastic vs acoustic
	- Homogenous vs heterogenous materials

### Piezo-electrics
- Make sure you understand how the piezo-electric effect works
- how the piezo-electric material turns the mechanical energy into electrical energy on a molecular / atomic level.


## Piezo-electronics
- &#9745; Choose the correct resonance frequency depending on the materials

# Design
## Piezo
### Electrical simulation
- &#9745;  Create an equivalent resonant circuit for the piezo-element to use in LTSpice-simulations

### Mechanical simulation
- Think about mechanical adaptations for waterproofing / impedance matching / inital testing

## Driving electronics
### Driving inverter
- &#9745; Design / dimension the driving inverter and simulate in ltspice together with the piezo-electric
- Create in KiCad

### Connector
- Choose an appropriate connector type for the driving part

## Analog front-end
### ADC selection
- Choose an ADC which can sample up to 10 MHz (so we can drive Piezo's up to 5 MHz)
	- Design circuitry around it, make sure it is isolated from the inverter

### Pre-amplifier
- Design a preamp with a low source impedance to push the piezo through the cable
- Make sure you can integrate the preamp with the sensor

### Connector
- Choose an appropriate connector for transmitting the amplified signal.
	- See if you can use the same one for the driving part as you can for the sensing part (not necessarily)


### PWM generation

### LNA design

# Setup

## Piezo-electric transducer availability
- Buy the piezo-electric (UB161M7)
	- Buy at DigiKey: https://www.digikey.de/en/products/detail/pui-audio-inc/UB161M7/6071956
	- Circular shape, positive internal ring, negative external ring (good for shear waves)
	- resonance frequency: 1.7 MHz
- Characterize the piezo-element with a VNA
	- Check the source impedance, The resonance frequency, The resonance impedance
	- Make / Buy an SMA to 2-terminal adapter so you can simply connect your piezo-electric element.
	- Make sure to calibrate the end of the SMA using a 50 ohm resistance with MINIMAL PARASITICS
	- Encapsulate 2 of them in a transparent, electrically insulating layer (epoxy, RTV silicone, Parylene)
		- Make sure the impedance is appropriate for transferring vibrations to other materials.


## Driving the piezo
### Waveform
- Check if a bandpass filter is needed to filter out the high / low frequency components
	- We're getting pretty close to the limits of what the FET driver + FET can do at 4-5 MHz.