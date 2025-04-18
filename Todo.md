# Acoustic Emissions structure 
## Amplifier
### Preamplifiers
- High impedance
- Enhance signal power with minimal noise addition (similar to an LNA)
- Usually highly linear

### Amplifiers
- Focus is pure power addition.
- Low-impedance


## Analog signal processing
- Add an analog integrator and compare with the digital one over frequency range

## Digital signal processing
- Add a small FPGA with the appropriate signal processing present.

## Acoustic emission simulations
- Check if you can use OpenEMS for propagation of acoustic waves in solids.

# Ideas
- Build your own variable gain amplifier for these kind-of high-frequency acoustic signals
	- sources: https://www.youtube.com/watch?v=ewYBc1jBDGM&t=508s&ab_channel=AllElectronicsChannel
- 