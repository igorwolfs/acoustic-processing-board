# DDR
## IDDRX1F
- Generic 1x gearing receive-interface using SCLK.
- Incoming clock: routed through SCLK clock tree.
- RST: reset to DDR registers.
- Q0, Q1: data at positive / negative edge of the clock.

Forces the place and route tool to use edge-flipflops for synchronization.

### Example: RGMII
RX-data-signals, as well as ctl-RX signal driven by the IDDRX1F-primtiive blocks.

```Verilog
IDDRX1F iddrx1f_rx_ctl (
	.D(RGMII_RX_CTL),
	.SCLK(gbl_rx_clk),
	.RST(rst_sync),
	.Q0(rx_ctl_sdr), // Data from rising edge
	.Q1()           // Data from falling edge (unused for RX_CTL)
);
```

## ODDRX1F
- Generic 1x gearing transmit-interface using SCLK.
- Outgoing clock: 

### Example: RGMII
TX-data signals, as well as ctl-TX signal driven by ODDRX1F-protocol.


```Verilog
ODDRX1F oddrx1f_tx_ctl (
	.D0(TX_DV),       // Data for rising edge
	.D1(TX_DV),       // Data for falling edge
	.SCLK(RGMII_TX_CLK),
	.RST(rst_sync),
	.Q(RGMII_TX_CTL)
);
```