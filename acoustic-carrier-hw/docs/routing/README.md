# 4 Layer Board

Since JLCPCB has only 4-layer 2-sided assembly, or single-sided 6-layer assembly, the best solution might be to 
- Do 4-layers assembly here.
- Ensure a big enough PCB, with power spread around the periphery.
- Use controlled impedance traces

This isn't a trivial task, given the large amount of supply voltages
- 0.675 V DDR3L reference voltage
- 1.2 V ethernet power
- 1.35 V DDR3L supply voltage
- 2.5 V auxiliary supply voltage
- 3.3 V core supply voltage
- 5 V main supply voltage

## Examples
### SDR Based Comms experiment platform
- Github link: https://github.com/gabriel-tenma-white/sdr5
- Link: https://www.eevblog.com/forum/fpga/4-layer-board-for-zynq-and-ddr3/

Advice: 
- All DDR traces must form a microstrip or stripline against the closest ground plane (usually 0.1mm away) which must be solid and have no breaks under the traces
- All ground and power pins on both the SoC and DDR chip should be accounted for; either they need to go to a plane, or have a decoupling cap right under the balls that goes to a plane. Every ground ball should have its own via, but a cluster of e.g. 4 ground balls are allowed to be connected together and grounded using 3 vias spread apart.
- If using a power plane, it must be stitched to the ground plane using a capacitor every 1-2cm, with higher density near signal layer transitions. For example, if a few DDR signals go from top to inner layer, you need a stitching capacitor or two around the via transition.

### SqueakyBoard
- Github link: https://github.com/regymm/SqueakyBoard/tree/master
- 

## Application notes
### DDR3
- STM32MP1 - AN5122 Routing application board link: https://www.st.com/resource/en/application_note/an5122-stm32mp1-series-ddr-memory-routing-guidelines-stmicroelectronics.pdf
