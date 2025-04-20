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
### Build your own variable gain amplifier
- Build your own variable gain amplifier for these kind-of high-frequency acoustic signals
	- sources: https://www.youtube.com/watch?v=ewYBc1jBDGM&t=508s&ab_channel=AllElectronicsChannel

CON:
- Too easy
- No real purpose, should target an application

Maybe integrate this into an a pre-existing project.

### Build a sonar-system
PRO:
- It's low-frequency / large wavelength so no real impedance matching issue
- There's lots of filtering and beamforming that can be done here. Some of this can be done in an analog way.

CON:
- You need an underwater setup
- You need some pretty expensive components
- You need well-characterized piezo-material

### Build a material characterizer using piezo-electrics

PRO:
- Low to mid-frequency
- High impedance signals that need amplification and signal processing
- Cheaper (Sticking to < 15 MHz sps, the ADC price can go as low as a few dollars)
- Can introduce a cheap-ish FPGA for DSP 
- Can introduce multiple analog circuitry to extract analog parameters (e.g.: raw RMS, band-pass filters, preamps)
