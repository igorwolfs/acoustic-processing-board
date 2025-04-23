# TODO

## Physics
- Make sure you understand the terms in the wave equation
	- The different types of waves (longitudinal vs transverse)
	- Difference between elastic vs acoustic
	- Homogenous vs heterogenous materials
- Make sure you understand how the piezo-electric effect works, how the piezo-electric material turns the mechanical energy into electrical energy on a molecular / atomic level.


## Get the Piezo-electric
- Choose the correct resonance frequency depending on the materials
- Buy the piezo-electric (UB161M7)
	- Buy at DigiKey: https://www.digikey.de/en/products/detail/pui-audio-inc/UB161M7/6071956
	- Make sure to buy some OPAMP and power supply chips for prototyping
- Characterize the piezo-element with a VNA
	- Make / Buy an SMA to 2-terminal adapter so you can simply connect your piezo-electric element.
	- Make sure to calibrate the end of the SMA using a 50 ohm resistance with MINIMAL PARASITICS

## Circuit design and simulation
- Create an equivalent resonant circuit for the piezo-element to use in LTSpice-simulations
- Circuit design for the transmitter
	- (FET) Driver for low-impedance driving of the piezo-element using a PWM from an stm32-nucleo.
	- Low-pass filter to make sure its frequency content contains mostly the resonance frequency.
- Design a receiver-LNA for the receiver frequency
- After that, put a bandpass in place of about 20 % x the BW
- Amplifiy again after that if necessary
- Make sure to transfer the signal impedance so it's small enough.
- ADC measuring
	-  Nucleo sampling rate
		- 9 MSPS, 6 bits | 7.2 MSPS, 8-bits | 6 MSPS - 10 bits | 5.14 MSPS: 12 bits
	- BETTER ALTERNATIVE: register both the wave that's transmitted and the received wave with an oscilloscope so they're on the same time-base: (1.25 GSa/s over 4 channels = definitely enough)


## Practical setup
- Coat the piezo-element with epoxy/another waterproof substance
