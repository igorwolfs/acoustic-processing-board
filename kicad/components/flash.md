# Flashing on FPGA

## JTAG (VCCIO8)

### CFG
xxx
### Pins

- TDI, TMS, TDO (4.7 kOhm pullup)
- TCK (4.7 kOhm pulldown)


## SPI
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
Orange Crab uses  W25Q128JVP, 128 M bit quad-spi NAND flash.
