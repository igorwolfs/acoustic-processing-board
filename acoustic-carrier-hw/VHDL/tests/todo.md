# GOAL

The goal here is to check whether the frequencies and the clock resources are sufficient to route everything through the ECP5U.

# Process

We create a dummy peripheral for every peripheral, with the appropriate settings for

- clock buffering
- outputs
- inputs

into the right pins.

# Next
Make sure to combine all peripherals into one signal TOP-file
- Call all peripherals inside that top-file
- Top file is supposed to have the relevant inputs and output pins mentioned. as in the test-pin-setup constraints file
- All clocks should be toggled and defined from the outside (so from the top-file)
- Simulation should run smoothly


## ULPI
### Clock
- 60 MHz
- Inputted from the ulpi-clock bus
- No buffers or anything mentioned
	- So probably needs to be defined with external limitations


## ADC_CLK
### ADC-clock
- Generated from 100 MHz through PLL
- This is simply assigned from the RX
- Which is weird, I would expect it to be generated from the ETH-input.


## DDR3
- Speed: 10 ns
- Increase that to 250 MHz
- Second PLL is used for this


## RGMII Interface
- RX, TX clock are both 125 MHz
- RGMII_TX_CLK should be sent to the PHY (output)
- (I think) RGMII_TX_CLK should be derived from the PLL -> so that's an error
- Try adding the extra clock pin over here and inputting it into the RGMII peripheral.


## Conclusion
Looks good

# Next
- Define the correct constraints and clock pins as if you were using the physical FPGA
- Run everything