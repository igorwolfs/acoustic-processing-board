
### Importance of transmission line length

For a lossless transmission line of characteristic impedance $Z_0$, electrical length $\ell$, and propagation constant $\beta$, terminated in a load $Z_L$, the input impedance is

$$
Z_{\mathrm{in}}
= Z_0 \;\frac{\,Z_L \;+\; j\,Z_0\,\tan\bigl(\beta \ell\bigr)\,}
                   {\,Z_0 \;+\; j\,Z_L\,\tan\bigl(\beta \ell\bigr)\,}.
$$

- If $Z_L \neq Z_0$, the $\tan(\beta \ell)$ term makes $Z_{\mathrm{in}}$ generally complex (reactive + resistive).
- If you choose $Z_L = Z_0$, it simplifies to

$$
Z_{\mathrm{in}} = Z_0,
$$

purely real and independent of the line length $\ell$.

**Reflections are caused by phase-shifts AND impedance discontinuities, not by phase-shifts alone.**