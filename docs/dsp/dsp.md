# Filters
## L-Tap filter
### Design
1. Define behavior at specific magnitude and phase
2. Define the characteristic phase-delay
3. Define Ripple / Tolerance in each band (e.g.: 0.1 dB in passband)
4. Total length (longer is better, shorter is less resouces + lower latency)

### Choose design method
Choosed the windowed sinc method

### Ideal infinite response computation

$$
h_{ideal}[n] = \frac{\sin\left(\omega_c \left(n - \frac{L-1}{2}\right)\right)}{\pi \left(n - \frac{L-1}{2}\right)}, \quad n = 0, 1, \dots, L-1
$$
where $\omega_c = 2\pi \, f_c / f_s$.$


#### Multiply by window w[n] to control side-lobes

$$
h[n] = h_{ideal}[n] \times w[n]
$$

#### Compute and quantize coefficients
- Compute real-avalued taps using python
- Scale them to your fixed point format
- Round to minimize quantization error

#### Verify & pipeline for FPGA
- Simulate in python / matlab
	- Impulse response
	- Magnitude and pahse response
	- Group delay
- Test with representative signals
- Implement in FPGA as 
	- shift-register of depth L.
	- L parallel multipliers feeding into L-stage adder tree.
	- Registers between stages to meet 35 MHz timing.

**Initial latency: L-1 cycles, then 1 filtered sample / cycle**