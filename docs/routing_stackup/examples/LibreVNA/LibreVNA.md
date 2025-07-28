A perfect example of how to route a 6-layer baord with high-speed analog signals.



# "High-speed" analog
## PORT 1:

Note the actual ADC frontend here is dimensioned for frequencies below 300 kHz.


### ADC - MCP33131D-10

#### Specs:
- 1 MSPS ADC
- Differential input

### Fully diff-amp: THS4521
- THS4521IDGKR (same as the one that I use)
	- Lower frequency however + resistive feedback

#### Feedback
- Seems to have only a 6.8kOhm resistor in feedback configuration, no additional input resistance.

### Mixer: LT5560 
- Mixes down to 250 kHz


### 10 dB attenuator
4 resistors.
28 ohm impedance:
- 20 * log((50-28) / (28+50)) = -11 dB return loss
- Assuming 50 ohm characteristic impedance at mixer input.

### Low-pass and conversion from 250 ohms to 28 ohms impedance

Impedance matching circuit to change the impedance characteristics of the signal.

#### Pins
- Local oscillator inputs (oscillator signals come from the MAX2871)

### Mixer (ADL5801)
Converts down to intermediate frequency (60 MHz)

# High-speed digital

## MAX2871 (Clock generation)
PLL / Clock synthesiser that generates signals between 23.5 MHz and 6 GHz.
- Control through SPI
- Refernece oscillator

### Pins
- RFOUTA, RFOUTB are all meant to transfer high-frequency digital clock signals to mixers and the likes.
	- They are all terminated with 50 ohm pull-ups

# Digital

# Power
## Power supply levels
- 5V
- 6V
- 3.3V
- Vccint (not sure what voltage level this is)