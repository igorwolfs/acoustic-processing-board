# Decoupling
1.35 V
- Decoupling:
	- 3x22 uF
	- 2x10 uF
	- 1 uF
	- 0.1x10 uF
	- 2x10 nF
- Logicbone:
	- 5x0.1 uF
	- 4x10 uF
	- 47 uF

0.675
- Decoupling
	- 2x10 nF
	- 2x0.1 uF
- logicbone
	- 2x0.1 uF

VDDR_IO and VDDR_CORE are split with a ferrite
- both have 10 uF, 3x100 nF, 3x10nF capacitance

So more decoupling than logic bone, however no ferrite -> should be good though

Think about adding ferrites, check recommendations.

## Use a Ferrite:
- BLM18PG121SN1D
- DCR: 0.05 (is this acceptable) -> DCR for example schematic 

# DDR3 Connections
## DQ groups
- Pins UDM, UDQS, DQ15..8 should be on a bus together and length matched together
- Same with the lower dq-group

## Address group
- ADR [0:14], BA[0:2],CLK,CLK#,CLKE, WE#,CAS#,RAS#,CS#,ODT, RST should be drawn and matched together.