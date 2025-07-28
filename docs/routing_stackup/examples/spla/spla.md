# SPLA

Goal of the project is to create a logic analyzer analyzing the nintendo ppu's.

# High-speed analog
## ADC1173

3 of these ADC's are driven by buffers.


### Specs
- Sampling rate: 15 MSPS
- 8 bit accuracy

## LMH6611

Inputs come from
- ASCALDE G / B / R

Used with the possibility of a second-order active low-pass configuration.
- Initial RC-configuration
- Capacitor feedback, initiates roll-off at the frequency set by the RC filter (C feedback and R between Vin and V+).
**IMPORTANT**: When positive feedback is present, don't assume V+ == V-.


However at the moment none of the required values are populated (feedback capacitor, feedback resistors).


### Specs
