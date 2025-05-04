# Flashing on FPGA
```
The flash voltage should match the VCCIO8 voltage.
It is recommended to use an SPI flash device that is supported in Diamond Programmer. To see the supported list of
devices, go to Diamond Programmer, under the Help menu, choose Help, then search for SPI Flash Support.
For SPI flash devices that are not listed in the SPI Flash Support, using the custom flash option may allow a nonsupported device to work.
```
Main reason seems to be the mathcing of Vcc_IO8 with the flash voltage.


## JTAG (VCCIO8)

### CFG
xxx
### Pins

- TDI, TMS, TDO (4.7 kOhm pullup)
- TCK (4.7 kOhm pulldown)


## SPI

Take the W25Q128JVSIQ


### SSPI (Slave SPI)

- CFG[2] = 0
- CFG[1] = 0
- CFG[0] = 1

### MSPI2 Configuring master SPI-port
To enable Master SPI configuration port, apply the settings below for the CFG pins on the ECP5/5G device:

Shared pins: 
- D[3:0], CSSPIN, DOUT

Dedicated pins
- PROGRAMN, INITN, DONE

#### cfg
- CFG[2] = 0
- CFG[1] = 1
- CFG[0] = 0

-> Configure this one by default, with connection of CFG_0 and CFG_1 to output so we can still change from SPI master to SPI slave if that were desired

# Example
## OrangeCrab
Orange Crab uses  W25Q128JVP (at 3.3 V), 128 M bit quad-spi NAND flash. (Serial NOR flash) / 16 MByte
- 128MBIT
- SPI_CONFIG_SS is pulled high.
	- So by default it is deselected
	- Probably pulled low by the FPGA
- D0..D3 floating

## ulx3
Uses IS25LP128F-JBLE flash (NOR Flash) / 16 MByte
- 128MBIT
- all spi pins are pulled high with a 4.7 kOhm resistor
	- Which is weird because it's push-pull, so except ofr the slave-select nothing should really be done.
