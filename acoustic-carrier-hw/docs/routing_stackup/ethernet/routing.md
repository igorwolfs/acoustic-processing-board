# RGMII

- Frequency: 125 MHz
- RGMII interface has 50 ohm impedance traces


## Differential ethernet impedance
Differential impedance is about 100 ohms by defautl

# Pairs
- Incorrect channel order for A, B, C, D-channels
- 50 ns +- 10ns in propagation delay

## Groups
- RGMII transmit groups (GTX_CLK, TX_EN, TXD[3:0])
- RGMII receive groups (RX_CLK, RX_DV, RXD[3:0])
- Skew: 0.06 ns per step
	- control / data signals: 4-bit skew adaptation (2**4-1) * 0.06 = 0.9 ns
	- clocks: 5-bits skew adaptation: (2**5-1) * 0.06 = 1.86 ns

