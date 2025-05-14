# White noise from resistance

Noise produced by a resistor is.

$S_v(f) = 4*k*T*R$ in $[\frac{V²}{Hz}]$

Bringing it back to voltage

$e_{n}(f) = \sqrt{S_v(f)} = \sqrt{4*k*T*R}$  $[\frac{V}{\sqrt(Hz)}]$

So to get the total noise at a frequency, you have to integrate the noise from the entire bandwidth to get there.

Because white noise is uniform, this reduces to:


$$
V_{\mathrm{rms}} \;=\; \sqrt{\int_{0}^{B} S_v(f)\,\mathrm{d}f}
\;=\; \sqrt{S_v\,B}
\;=\; \sqrt{S_v}\,\sqrt{B}
\;=\; e_n\,\sqrt{B}
$$

- B: the bandwidth (in Hz)

So use low-pass filters to reduce noise.

# Flicker noise

Noise proportional to the inverse of the frequency ($\frac{1}{f}$).

Due to random fluctuation processing (charge carrier trapping / detrapping), mobility changes, material-structure shifts etc..

# Shot noise

Noise due to arrival of discrete charge carriers across a potential barrier.

