# Options
## Flashing the SPI
Use a PMOD for this, make sure the QSPI is put there in PMOD configuration.



## Flashing the JTAG
Check the JTAG protocol used

### FT2232-based
- Using an FT2232-based chip (FTDI: https://github.com/gregdavill/ecpprog)

### CMSIS DAP-based (2x5)
- Using a CMSIS DAP-link probe (https://github.com/adamgreig/ecpdap)
- https://www.amazon.com/CMSIS-DAP-DAPLink-Cortex-M-Program-OpenOCD/dp/B0BRW634QV?th=1


#### Pinout example (varies strongly):
bottom:
- 1: UART_RX
- 2: UART_TX
- 3: nRST
- 4: TDO
- 5: TDI

top:
- 1: TCK
- 2: GND
- 3: SWDIO
- 4: 3V3
- 5: 5V