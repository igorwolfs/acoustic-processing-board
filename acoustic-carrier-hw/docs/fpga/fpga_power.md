General recommendations
- 3 % accurate power supply recommendations
- 

# FPGA Core power supply
V (LFE5U)

# Vcca: analog power supply
-> Should be well-isolated from excessive noise!


# Vccaux: auxiliary power supply
-> 2.5 V

# Vccio: Bank voltage supply
-> should be between 1.2 and 3.3 V, dpeends on the use of the bank.




# Filtering

# Example
## OrangeCrab

### Main supply
- Powered by a Lithium-Ion battery, that has a BQ24232-IC in between.
- Supplied from USB-bus (5 V)

Outputs VSYS, which is (probably) between 4.4 and 5.5 volts

### 3.3 V, 1.1, 1.35 V
- Are simply delivered through the 5 V bus by a FAN53541 x 3
- 3 x switching converter

### DDR3L VTT generator
TPS51206
- Creates VTT (0.675 V) for the DDRL3


### 2.5 V
VccAUX: auxiliary power supply

- NCP115CMX250TCG used (LDO)


### VSYS ()


## ButterStick
- USB power input

### TLV62569DRL (max 2 amp output)
Used for bringing voltage from 5 V to
- 3.3 V
- 1.2 V (For some reason 2 LDO's here)
- 2.5 V
- 1.35 V DRAM



### DRAM supply
http://www.ti.com/lit/ds/symlink/tlv62569.pdf
