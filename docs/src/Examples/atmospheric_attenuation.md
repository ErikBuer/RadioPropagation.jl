# Atmostpheric Attenuation

Lets recreate the classic atmospheric attenuation figure from [1].

```@example AtmostphericAtten
using ..RadioPropagation
using Plots

frequency_ghz = collect(1:600);


attenuation_db_km = RadioPropagation.atmospheric_attenuation_db_per_km.( frequency_ghz );

plot(
    frequency_ghz, attenuation_db_km,
    xlabel  = "Frequency [GHz]",
    ylabel  = "One-way loss [dB/km]",
    title   = "Atmospheric Attenuation.",
    label   = "Standard",
    yaxis=:log,
    dpi=300
)


attenuation_db_km = RadioPropagation.atmospheric_attenuation_db_per_km.( frequency_ghz, 288.15, 0 );

plot!(  frequency_ghz, attenuation_db_km,
        label = "Dry air",
        yaxis=:log,
)

savefig("attenuation_example.svg"); nothing # hide
```

![Atmostpheric attenuation image](attenuation_example.svg)

## References

[1] Rec. ITU-R P.676-12, Attenuation by atmospheric gases and related effects, ITU-R 2020.
