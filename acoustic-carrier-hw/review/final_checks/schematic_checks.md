# FPGA-CONFIG-FLASH OK
## QSPI pull-up (6.1 - Master SPI Modes)

- Data-line pull-ups with 10 kOhm. ()
- SS pins pull-up with 4.7 kOhm. (ok)
- MCLK pull-up with 1 kOhm. (Output with weak pull-up)


## JTAG
(6. Configuration Considerations)

- TDI, TMS, TDO: pul-up with 4.7 kOhm
- TCK: pull-down with 4.7 kOhm

## Config-pins
- INITn: 4.7 kOhm - ok
- FPGA_DONE: 4.7 kOhm - ok
- FPGA_RESETH / PROGRAMb: 4.7 kOhm pull-up - ok
	- Default high, button press low

### Config
- CFG0: 0, CFG1: 1, CFG2: 0

OK for master slave mode.

# 