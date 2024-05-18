# RadioPropagation.jl

[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://erikbuer.github.io/RadioPropagation.jl/dev/)

Julia package implementing radio propagation models.

The following is implemented:

- Two-Ray propagation model.
- Rain attenuation for frequencies in the range 1-400 GHz.
- Fog attenuation for frequencies above 5 GHz.
- Atmospheric attenuation for frequencies up to 1000 GHz.

## Installation

The package can be installed with the Julia package manager.
From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```pkg
pkg> add RadioPropagation
```

Or, equivalently, via the `Pkg` API:

```julia
julia> import Pkg; Pkg.add("RadioPropagation")
```

## Examples

### Two-Ray Propagation

Below is an example showing the two-way loss for two-ray propagation compared to that of free-space propagation.
The code for the eample can be found in the function documentation.
![Image](figures/example_figure.png?raw=true)

### Atmospheric attenuation

Atmospheric attenuation calculated as per [1].

```julia
using Plots

frequency_ghz = collect(1:1000);
attenuation_db_km = RadioPropagation.atmospheric_attenuation_db_per_km.( frequency_ghz );

plot1 = plot(   frequency_ghz, attenuation_db_km,
                xlabel  = "Frequency [GHz]",
                ylabel  = "One-way loss [dB/km]",
                title   = "Atmospheric Attenuation.",
                #ylims  = (),
                label   = "Standard",
                yaxis=:log,
                dpi=300
)

attenuation_db_km = RadioPropagation.atmospheric_attenuation_db_per_km.( frequency_ghz, 288.15, 0 );

plot!(  frequency_ghz, attenuation_db_km,
        label = "Dry air",
        yaxis=:log,
)

savefig("figures/attenuation_example")
```

![Image](figures/attenuation_example.png?raw=true)

[1] Rec. ITU-R P.676-12, Attenuation by atmospheric gases and related effects, ITU-R 2020.
