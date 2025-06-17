# Routing

## Signal Layer Changes
Make sure to add vias for high-speed signal so the return path can travel along a path of minimum impedance (so close to the signal path on a ground plane / power plane).

# Stackup
## JLCPCB-Stackup choice
- JLC06161H-3313 standard / finished thickness 1.54mm +-10%

### JLCPCB calculator
50 ohms coplanar single-ended:
- 50, Coplanar Single Ended, L1, /, L2, width: 0.1565, /, distance from GND: 0.5080

100 ohms coplanar differential pair:
- 100, L1, /, L2, width: 0.1217, trace_width: 0.2032, distance from GND: 0.2032

90 ohms coplanar differential pair:
- 90 Coplanar Differential Pair, L1, /, L2, width: 0.1554, trace_width: 0.2032, distance from GND: 0.2032

### Choice
Choose the stackup
- SIG - GND - (CORE) - PWR/SIG - GND - (CORE) - GND - SIG

## Signal-Ground Separation
Planes that are further apart, have a higher impedance characteristics (so less capacitance, more inductance).
The fields have to spread so widely that EMI problems will be caused.

So for example, if plane 3-4 are spaced further apart, do not make one of those planes the reference GND plane.

Rules:
- 4-layer board: don't put power on 2, ground on 3
- 6-layer board: don't put power on 2, ground on 5

## Containing fields between SIG and PWR plane
### Why does it work?
a DC PWR plane is basically the same as a DC ground plane. The AC return current can flow on the power plane, induced by the signal on the SIG-plane. Then however this charge needs to find its way to a GND-plane, which it does through decouplign capacitors.

So although you can use a PWR plane as AC ground, the charge itself still needs to find its way to actual DC ground. 

So:

- The impedance to GND is slightly higher
- The decoupling between PWR and GND here is really important.
- Caps only decouple up to a certain frequency.
- If there is a split in the power plane, and a trace crosses a power plane, this will lead to massive impedances for the return path.
	- However in case of a closely spaced ground plane, the AC current can jump to the adjacent ground plane and continue to travel there.

### Solving the decoupling capacitor issue
- Placing a GND plane close, right next to the PWR plane creates a massive planar "capacitor" with a low-impedance AC-path between power and GND.

### FOR MORE CHECK OUT
- Transmission line theory / EM wave propagation
	- Modelling the trace as a distributed series inductance and shunt capacitance.
- Laws of EM: 
	- Boundary conditions for the wave equation in between 2 conductive geometries.


1. Signal changes rapidly (e.g.: from 0 -> 3.3 V)
2. Electric field changes rapidly in the dielectric between the signal and reference plane
3. This induces electric displacement field (D = eps * E)
4. (Amperes law) change in displacement field leads to change in magnetic field around the changing D-field
5. Surface current gets induced, which locally satisfies amperes law (induced on the reference plane)
	- Changing H field induces a voltage gradient
	- Voltage gradient causes electrons to move (conduction current)
	- This current is the AC return current.
6. **The AC induced return current together with the displacement current in the dielectric satisfy Ampere's law (with Maxwell's addition).** to generate the accompanying H-field.

## Power Ground Separation
Never put a power layer in a board without an adjacent GND plane.



### Q: WHY NOT?

## Good 6-layer stackups
### Stackup 1 - NOT cost effective
- POWER - SIG/GND
- CORE
- POWER - GND
- CORE 
- SIG/PWR - GND

Big CONS: 
- You have only 2 signal layers, for a 6 layer board.
- The signal needs to travel all the way from layer 1 to layer 6 in case of changing signal layers

### Stackup 2 - Better
- SIG/PWR - GND
- CORE
- SIG/PWR - GND
- CORE
- SIG/PWR - GND

Better: in this case the signal only needs to travel from layer 1->3 or 3->5.

# Sources:
- [LIVE] How to Achieve Proper Grounding - Rick Hartley - Expert Live Training (US), **Link:** https://www.youtube.com/watch?v=ySuUZEjARPY&ab_channel=Altium

- "Signal and Power Integrity - Simplified" (Book): THE foundational text for understanding these concepts practically. Chapter 4 (The Physical Basis of Transmission Lines)
- Key Paper: Bogatin, E. (1999). "No Myths Allowed! How Return Current Really Flows, and What to Do About It" (EDN Article)