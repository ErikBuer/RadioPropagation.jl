using Test



push!(LOAD_PATH, expanduser(".")) # Assumed to be ran from the repl folder.

#include("RadioPropagation.jl")
using RadioPropagation


# Example code plotting signal strength as function of range, compared to free space power spread
using Plots

c = 3e8;

transmit_height_m	= 2;
receive_height_m	= 10;
target_range_m		= LinRange(20, 100, 10000);
transmit_frequency_hz =3e9;
λ = c/transmit_frequency_hz;
Γ1 = -1;
Γ2 = -0.6;

F²( Γ ) = RadioPropagation.two_ray_propagation.( target_range_m, transmit_height_m, receive_height_m, transmit_frequency_hz, Γ );

F²1 = F²( Γ1 );
F²2 = F²( Γ2 );

f⁴_db( F² ) = 10*log10.( abs2.( F² ));

freespace_loss_db = 10 .*log10.(λ^2 ./( (4*π)^3 .*target_range_m .^4 ));
bias = freespace_loss_db[1]


plot1 = plot( 	target_range_m, f⁴_db.(F²1)+freespace_loss_db .-bias,
			 xlabel 	= "Range (one-way) [m]",
				ylabel 	= "Two-way loss [dB]",
				title  	= "Freespace VS two-ray propagation.",
				ylims 	= (-30, 6),
				label 	= "|F|⁴+L, Γ=-1",
				legend	= true,
				xaxis	=:log,
				dpi=300)
plot!( 	target_range_m, f⁴_db.(F²2)+freespace_loss_db .-bias,
	 	label = "|F|⁴+L, Γ=-0.6",
	 	xaxis	=:log )
plot!( 	target_range_m, freespace_loss_db .-bias,
	 	label = "L",
	 	xaxis	=:log )

gui();
display( plot1 )
savefig("example_figure")

# Unit test methods.

@testset "RadioPropagation.jl" begin
    @test RadioPropagation.two_ray_propagation( 2e3, 10, 12, 20e9, -1 ) == 1.9993946082759417 + 0.03479104696580754im;
    @test RadioPropagation.rain_attenuation_db_per_km( 'v', 30, 20 ) == 3.3400000000000003;
    @test RadioPropagation.rain_attenuation_db_per_km_circular_pol( 30, 20 ) == 3.6755027981960815;
end

