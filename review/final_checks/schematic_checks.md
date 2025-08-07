# FPGA-CONFIG-FLASH OK
## QSPI pull-up (6.1 - Master SPI Modes)

- Data-line pull-ups with 10 kOhm. ()
- SS pins pull-up with 4.7 kOhm. (ok)
- MCLK pull-up with 1 kOhm. (Output with weak pull-up)


## JTAG
(6. Configuration Considerations)

- TDI, TMS, TDO: pull-up with 4.7 kOhm
- TCK: pull-down with 4.7 kOhm

## Config-pins
- INITn: 4.7 kOhm - ok
- FPGA_DONE: 4.7 kOhm - ok
- FPGA_RESETH / PROGRAMb: 4.7 kOhm pull-up - ok
	- Default high, button press low

### Config
- CFG0: 0, CFG1: 1, CFG2: 0

OK for master slave mode.

# SPI Connections

- CS, Di, MCLK: OK
- Is CSSPIin2 a regular pin after boot? 

# Decoupling capacitors
- USB ULPI: OK
- FPGA: OK
- 

# Silkscreen Indicators
## Diodes 
- BZT52C6V8S: OK
- Red Led: OK
- 1N4148WS: OK

## Capacitors
- 

## IC's (pin 1)
### P1
- U201 (TPS2121RUX) -> Doesn't indicate pin1, does have 3 indicators
- Connector: OK
- DC-DC: ok
- OPAMP: ok (OPA376xx)
- FPGA: OK
- Capacitor: OK

### P3
- Oscillator: OK

### P6
- PMOD: OK
- FLASH: OK

### P7: 
- USB PHY controller: OK
- oscillator: ok
- Comparators: OK

### P8 Conectors
OK

### P9: ADC frontend
- Switch: OK
- Buffer: OK
- ADC: ok
- Buffer: OK

### P10
DDR: OK

### P11 Ethernet
- OK

## Transistors
- AO3401A: ok

# Pad vs Pin checks:
