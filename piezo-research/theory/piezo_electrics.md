# Piezo Electrics
## PZT
Most Piezo-electrics are ceramics, like PZT (lead Zirconate Titanate). This is the de-facto industry standard.
- High efficiency of converting mechanical into electrical signal (little heat conversion)
- Tunable properties (can design frequency-dependent ones)

### Types of PZT
- Hard PZT
	- PZT-4, PZT-8, which is used for high power, high frequency AE sensors.
- Soft PZT
	- PZT-5, higher sensitivy but less stable at high power over time. (so less common in AE sensors)

### PZT Geomtries used for Material characterization
#### Discs
- Electrodes: 2-sides
- Resonance: diameter-to-thickness ratio.
- Applications: Ultrasound, AE-sensors, sonar

#### Rings (Washers)
- Electrodes: inner / outer
- Resonance: diameter-to-thickness ratio.
- Applications: Actuators for linear motion (radial vibrations)

#### Patches
- Applications: EMI-based damage detection, Guided wave SHM (ultrasonic testing)

## Suppliers
- PI Ceramic, APC international, CTS Corp, Morgan advanced materials, Sparkler Ceramics Ceramics

## Resonant Frequencies
Each of these PZT's usually have a specific resonant-frequency with high Q-factor (resonance peak).

### Broadening frequency sensitivity
There are a 3 main things (mechanically) that can be done to broaden the frequency range:
- Intentional damping of the resonance, lowering the Q-factor in order to broaden the frequency sensitivity around the resonance peak.
- Mechanically redesigning the sensor housing and couplant layers to
	- Spread the frequency response.
	- Minimize reflections / resonances in the sensor body.
	- Flatten the amplitude curve across a wider frequency band.
- Using multiple piezo-elements:
	- Resonating at different resonant frequencies.
	- Averaging out geometrically over a wider area.

Another option is to compensate electronically for the loss in gain, although that can only be done to a certain extent.

### Frequency range choice for crack detection
- small wavelength / high frequency: Minimum size of a detectable defect is half the wavelength used.
	- Higher detection resolution
	- Less penetration
- large wavelength / low frequencies: Lower frequencies have smaller don't get reflected as much and can penetrate deeper into the material. 
	- Coarse defect detection
	- Material characterization (youngs modulus through TOF, etc..)
- Nonlinear techniques are sometimes used for specialized crack detection.

## Minimizing reflections

- Impedance: Use matching layers with intermediate impedance
- Length: CHoose the right layer thickness (often $\lambda / 4$)
- Broad frequency ranges require multiple matching layers, each one meant for its own bandwidth.

# PZT equivalent circuits

## Butterworth-Van Dyke
The circuit is often used to model piezo-electric behaviour.

<img src="images/BVD.png" width="100" height="200" />

With 
- $C_{p}$ the physical capacitance between 2 terminals.
- LCR-branch for mechanical resonance modelling.

## Parameters
### Static capacitance
Measured using a Schering bridge. This capacitance value is often measured at 1 kHz. ($C_{p}$)

Low frequency and standard conditions are used to minimize effects of resonance.

### Resonant impedance
Impedance at resonance, namely frequency where inductance and capacitance cancel each-other out.

### Quality factor

$$Q = \frac{1}{R} * \sqrt{\frac{L}{C}}$$

### Electrical-Mechanical coupling coefficient
A measure of conversion efficiency between electrical and acoustic energy.

# Purchasing links
- PZT-8: https://de.aliexpress.com/item/1005008105542320.html?spm=a2g0o.productlist.main.16.2001A3zfA3zfma&algo_pvid=8f9e45dd-25bc-4688-8571-f212cbe682ef&algo_exp_id=8f9e45dd-25bc-4688-8571-f212cbe682ef-15&pdp_ext_f=%7B%22order%22%3A%22-1%22%2C%22eval%22%3A%221%22%7D&pdp_npi=4%40dis%21EUR%2123.57%2122.39%21%21%21190.85%21181.29%21%402103956a17450027423106406e4cf4%2112000043789602723%21sea%21DE%213638632815%21X&curPageLogUid=UM1KEZc7mbQo&utparam-url=scene%3Asearch%7Cquery_from%3A&_gl=1*wnvjw0*_gcl_aw*R0NMLjE3NDQ3MzM5OTIuQ2owS0NRandoX2lfQmhDekFSSXNBTmltZW9FNWZud0p2X29GeUpCZ0tSdVJJeW9NY3dVWEQ1ZGx4S19PTnZpY052M25jMlo2SFIwSWVsUWFBaVlBRUFMd193Y0I.*_gcl_dc*R0NMLjE3NDQ3MzM5OTIuQ2owS0NRandoX2lfQmhDekFSSXNBTmltZW9FNWZud0p2X29GeUpCZ0tSdVJJeW9NY3dVWEQ1ZGx4S19PTnZpY052M25jMlo2SFIwSWVsUWFBaVlBRUFMd193Y0I.*_gcl_au*OTYyMTQ3NzY2LjE3NDM1MDI5NjU.*_ga*MjA3NjAzOTYyNS4xNzM1NDc3NDg3*_ga_VED1YSGNC7*MTc0NTAwMjc0Ni45Mi4xLjE3NDUwMDM0NTAuNjAuMC4w
- PZT-4: https://de.aliexpress.com/item/1005004698600121.html?spm=a2g0o.detail.pcDetailBottomMoreOtherSeller.3.2975NBR6NBR62j&gps-id=pcDetailBottomMoreOtherSeller&scm=1007.40050.354490.0&scm_id=1007.40050.354490.0&scm-url=1007.40050.354490.0&pvid=928646fa-e4d6-44f7-a591-569f35610be7&_t=gps-id:pcDetailBottomMoreOtherSeller,scm-url:1007.40050.354490.0,pvid:928646fa-e4d6-44f7-a591-569f35610be7,tpp_buckets:668%232846%238107%231934&isseo=y&pdp_ext_f=%7B%22order%22%3A%228%22%2C%22eval%22%3A%221%22%2C%22sceneId%22%3A%2230050%22%7D&pdp_npi=4%40dis%21EUR%2112.11%2110.29%21%21%2113.45%2111.43%21%402103867617450028078698938e5cb7%2112000030141699911%21rec%21DE%213638632815%21X&utparam-url=scene%3ApcDetailBottomMoreOtherSeller%7Cquery_from%3A

# Sources
- https://www.youtube.com/watch?v=n0zfl2UsU3s
