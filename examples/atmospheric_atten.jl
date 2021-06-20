push!(LOAD_PATH, expanduser(".")) # Assumed to be ran from the repl folder.

#include("RadioPropagation.jl")
using RadioPropagation
using Plots

frequency_ghz = collect(1:1000);


attenuation_db_km = RadioPropagation.atmospheric_attenuation_db_per_km.( frequency_ghz );


plot1 = plot(	frequency_ghz, attenuation_db_km,
	 			xlabel 	= "Frequency [GHz]",
				ylabel 	= "One-way loss [dB/km]",
				title  	= "Atmospheric Attenuation.",
				#ylims 	= (),
				label 	= "Standard",
				yaxis=:log,
				dpi=300
				)


attenuation_db_km = RadioPropagation.atmospheric_attenuation_db_per_km.( frequency_ghz, 288.15, 0 );

plot!( 	frequency_ghz, attenuation_db_km,
	 	label = "Dry air",
	 	yaxis=:log,
	 	)

savefig("figures/attenuation_example")
