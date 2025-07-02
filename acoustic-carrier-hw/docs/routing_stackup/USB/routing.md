# Pin Selection

- USB0..7
- CLK: E13
- STP: E12
- DTR: E11
- NXT: D13
- RST: C13

## CLK pin
- Make sure to route the clock pin into the relevant clock input.


# Impedance Matching / Routing

- 60 MHz bus
- Clock should probably be connected to PCLKT1_0
	- Similarly in Trellisboard
- Clock is connected to ULC_GPLL1C_IN for EPC5UM5G_86

## Impedance / Trace control

- ULC_GPLL1C_IN: USB.REFCLK: Takes in a 60 MHz signal.


### Impedance control
- 50-60 ohm controlled impedance
- Length limitation to 3 inches
	- 76,2 mm

### Signal length limits
- All signals should be within 0.5 inches of CLKOUT
	- 0,5 inches = 12.7 mm
- Deepseek: < 25 mm mismatch for data lines
- Other models: 500 ps -> 3 inches -> 76 mm
- clock should be matched to data lines with +- 5 mm?

## Extra resistors
- Place 0 ohm termination resistor next to CLK

## ULPI
- ULPI_CLK_FREQ: 60 MHz
	- Period: 16.6667 ns

### Parameters

- Clock period:
	- USB3300: 16.67 ns
	- ECP5U-FPGA: 16.67 ns
- Input setup time: (control, data)
	- USB3300: 5 ns
	- ECP5U: 0 ns, or 1.46 ns (with PIO register having input data delay)
- Input hold time:
	- USB3300: 0 ns
	- ECP5U: 3.3 ns (max)
- Clock to output delay:
	- USB3300: max 5 ns, min 2 ns
	- ECP5U: max 6.8 ns, min: 5.4 ns

### Setup time margin

Requirement for the data to be stable before the clock edge.
* Time until the signal gets there, referenced to the previous clock edge
	* EQUATION: T_PROP_TIME = T_CO(MAX, SRC) + T_DATA_TRACE_LENGTH
* Time at which the signal should be there
	* EQUATION: T_REQ = T_PERIOD + T_CLOCK_TRACE_LENGTH - T_SETUP_REQUIRED
* So condition becomes:
	* T_PROP_TIME < T_REQ
	* T_CO(MAX, SRC) + T_DATA_TRACE_LENGTH < T_PERIOD + T_CLOCK_TRACE_LENGTH - T_SETUP_REQUIRED
	* T_PERIODIC - T_CO(MAX, SRC) - (T_DATA_TRACE_LENGTH - T_CLOCK_TRACE_LENGTH) > T_SETUP_REQUIRED

### Hold time margin
Requirement for the data to be stable after the clock-edge.

* Time until the data stops being shown, referenced to the previous clock edge.
	* EQUATION: T_PROPAGATION_FINAL_END = (T_PERIODIC + TCO(MIN, SRC)) + T_TRACE_LENGTH
* SO for the condition make sure that:
		* T_PERIODIC + T_HOLD_REQUIRED < T_PROPAGATION_FINAL_END
		* T_PERIODIC + T_HOLD_REQUIRED < T_PERIODIC + TCOO(SRC) + T_TRACE_LENGTH
		* TCO(SRC) + T_TRACE_LENGTH - T_HOLD_REQUIRED > 0

NOTE: everything is reference to the last clock-cycle, 


#### FPGA -> USB3300 PHY
Setup-time margin (Time for the data to be stable before the clock-edge at the PHY).
* Margin = Cycle time - FPGA's clock to output delay - PHY setup time	
	= T_cycle - T_CO(max) - T_su - T_skew [T_skew = T_data_trace - T_clk_trace]
	* Time it takes for the data to get to the receiver: T_CO(max) + T_data_trace
* Margin = 16.667 ns - 6.8 ns - 5 ns - T_skew = 4.867 ns - T_skew
	* So T_skew setup margin is huge (about 5 ns)


Hold-time margin (Positive means hold-time is met)
* Margin = Datapath delay (min) - Hold time requirement = Clock to output delay (FPGA_min) + PCB trace delay - PHY hold-time
	* Should be positive (so there's time let for the USB-PHY)
* Margin = Datapath-delay - 0 ns + 5 ns (so the hold-time margin is also pretty huge)

#### USB3300 PHY -> FPGA
* Setup-time margin = T_cycle - T_CO(max) - T_su - T_skew [T_skew = T_data_trace - T_clk_trace]
* 16.6667 - 5 ns - 0 ns + T_SKEW = 11.667 ns + T_SKEW (so T_SKEW can be huge)

Hold-time margin (Positive means hold time is met)
* Margin = Cycle time - PHY clock to output delay - FPGA hold time
* = 16.667 ns - 5 ns - 0 ns = 11.667 ns

## Sources
- https://ww1.microchip.com/downloads/en/AppNotes/en562704.pdf