# ADC Frontend
- We have to reduce the pp voltage that the ADC can measure to 1 V instead of 2 V.
- This because our differential amplifier only takes 1 V pp inputs.
- Check how much current the common mode pin requires and how much decoupling it needs
	- You might have to setup your own buffered common mode voltage
	