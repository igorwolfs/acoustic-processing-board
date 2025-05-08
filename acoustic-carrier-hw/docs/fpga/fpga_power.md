# General recommendations
(Check FPGA-TN-02115-1.1)

- 3 % accurate power supply recommendations

## Capacitors
- decoupling of 1 nF - 100 uF at DC suply lines
	- Place 10 uF ceramic capacitor (low-ESR) on voltage line
	- Add bulk capacitance 1 uF - 10 uF
	- Place at least 1 100 nF - 10 nF capacitors per device power pin
	- Add large electrolytic capacitor (100 uF) at power source
- Capacitor sizes: 0603 or 0805


### 3.3 V core supply (VCC)
PIN NUMBER: 6

#### Bulk capacitance
- 3x10 uF

#### HF decoupling
- 2x0.1 uF, 1x0.47 uF (HQ capacitors)


### Auxiliary power supply (VCCAUX)
PIN NUMBER: 2

#### HF decoupling
- 3x0.1 uF

### VCCIO (I/O driver supply voltage)
PIN NUMBER: 2 x 6 banks + 1x bank 8 = 13

### VREF (Input reference voltage)


## Inductors / Ferrites
- Add Ferrites of between 4 uH - 10 uH to avoid HF noise propagation

## Voltage / Current spike protection
- Include TVS (Transient voltage suppressors) where necessary
	- In our case especially, since we're dealing with 40 V - 10 Amp spikes on the lower board

# Filtering

# Example
## OrangeCrab

## Butterstick Filtering (not including buck-converter output)
### 2.5 V Vaux
- 3 x 100 nF

### Core voltage
- 3 x 10 uF
- 3 x 100 nF
- 3 x 1 uF

### 1V8 (Hyperram)
- 3 x 100 nF

## LogicBone
### VDDR
- 4 x 100 nF

### DDR3_VREF
- 2 x 100 nF

### VDDR
- 4 x 10 uF

### VCORE
- 4 x 100 nF
- 4 x 10 nF
- 6 x 10 uF

### VCCAUX
- 2 x 100 nF
- 4 x 10 nF

### VCCA
- 2 x 10 uF
- 2 x 100 nF
- 4 x 10 nF
- 3 x 10 uF

### Serdes (Voltage)
