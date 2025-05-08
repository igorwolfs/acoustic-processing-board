# IP Cores
There are enough opensource ethernet cores that contain both an RGMII as well as an RMII interface.
- http://github.com/alexforencich/verilog-ethernetVerilog-Ethernet%20(Alex%20Forencich)
- https://github.com/enjoy-digital/liteeth


# Magnetics and connectors
Use capacitors instead of magnetics, and keep the connections short.
Check the application note for more info.

Re-use the regular RJ45 connector you already use.


# MII
### RGMII vs GMII vs SGMII
GMII:
- 24-signal interface 
	- 8 TX pins
	- 8 RX pins
- Each byte is clocked, 1 bit per clock edge (so twice the data-rate)

RGMII:
- Halves the pin count
	- 4 TX pins
	- 4 RX pins

SGMII
- 2 high-speed differential pairs encoding all data
- Running at 500 MBps (requires SerDes alignment)