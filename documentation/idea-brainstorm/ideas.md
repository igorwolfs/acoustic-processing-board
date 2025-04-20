# Ideas

## Acoustic Emissions structure 
### Amplifier
#### Preamplifiers
- High impedance
- Enhance signal power with minimal noise addition (similar to an LNA)
- Usually highly linear

#### Amplifiers
- Focus is pure power addition.
- Low-impedance

#### Analog signal processing
- Add an analog integrator and compare with the digital one over frequency range

#### Digital signal processing
- Add a small FPGA with the appropriate signal processing present.

## Acoustic emission simulations
- Check if you can use OpenEMS for propagation of acoustic waves in solids.

### Build your own variable gain amplifier
- Build your own variable gain amplifier for these kind-of high-frequency acoustic signals
	- sources: https://www.youtube.com/watch?v=ewYBc1jBDGM&t=508s&ab_channel=AllElectronicsChannel

CON:
- Too easy
- No real purpose, should target an application

Maybe integrate this into an a pre-existing project.

### Build a directional sonar-system with beamforming

#### Discrete piezoelectric array
Beamforming is usually done with multiple small piezoelectric elements. Each element is driven separately from the other with a controlled time-delay.

#### Element type / Geometry
- Disc / Stack: used for 100 kHz - 1 MHz
- Cymbal transducers
- 1-3 composites

#### Spatial arrangements
- 1D / 2D with linear half wavelength spacing between each other.
- Cylindrical / Ring arrays for full-azimuth coverage.


#### PRO:
- It's low-frequency / large wavelength so no real impedance matching issue
- There's lots of filtering and beamforming that can be done here. Some of this can be done in an analog way.

#### CON:
- You need an underwater setup
- You need some pretty expensive components
- You need well-characterized piezo-material

## Build a material characterizer using piezo-electrics
Characterize materials using ultrasound.
Goal is to analyze and characterize materials groups such as plastics, composites and metals.


#### Sensor types
##### Resonant sensor
- Narrow frequency range: 150 kHz - 300 kHz
- Wide peak sensitivity

##### Broadband sensor
- Wide Frequency range (up to 2 MHz) 
- Flat frequency response
- Used when DSP is needed (frequency domain)

#### Mounting
- Wax / hot glue
- Magnetic clamps

Important is minimal energy loss, and the sensor having a low acoustic impedance compared to the material to be tested.

#### Amplifier + filters
- Minimize the effect of EM-noise / noise.
- Minimize filtering based on the material the measurement is done for.

#### Measured units
- usually measured in dB (dB = 20 . log (A / A_ref))
- energy of the signal (integral of the signal squared).


##### PRO
- Low to mid-frequency
- High impedance signals that need amplification and signal processing
- Cheaper (Sticking to < 15 MHz sps, the ADC price can go as low as a few dollars)
- Can introduce a cheap-ish FPGA for DSP 
- Can introduce multiple analog circuitry to extract analog parameters (e.g.: raw RMS, band-pass filters, preamps)

#### Interesting repos:
- Piezo Z-axis sensor: https://github.com/pyr0ball/pyr0piezo
- Active vibration control with piezo-electric materials: https://github.com/bensu/piezo_control
- Piezo-vibration sensor (2-6 kHz), series of videos: https://github.com/blown34/vibesensor

#### Interesting products:
- 30 kHz - 500 kHz piezo transducer: https://www.ti.com/tool/BOOSTXL-TUSS4440
- TOF sensor EVAL boards (not including the piezo) (100 kHz - 2 MHz), there's a whole range of them: https://www.analog.com/media/en/technical-documentation/data-sheets/max35101evkit.pdf- 
- Heat / Flow meter + PCB example + Firmware: https://www.analog.com/en/resources/reference-designs/maxrefdes70.html#rd-overview
- Ultrasonic setup and signal processing (31.25 kHz - 4 MHz): https://www.ti.com/product/de-de/TDC1000-C2000EVM/part-details/TDC1000-C2000EVM
- Ulatrsound TX pulser eval board: https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ProductDocuments/UserGuides/20005656B.pdf
