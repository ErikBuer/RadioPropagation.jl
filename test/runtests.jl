using Test



push!(LOAD_PATH, expanduser(".")) # Assumed to be ran from the repl folder.

#include("RadioPropagation.jl")
using RadioPropagation

@testset "RadioPropagation.jl" begin
    @test RadioPropagation.two_ray_propagation( 2e3, 10, 12, 20e9, -1 ) == 1.9993946082759417 + 0.03479104696580754im;
    @test RadioPropagation.rain_attenuation_db_per_km( 'v', 30, 20 ) == 3.3400000000000003;
    @test RadioPropagation.rain_attenuation_db_per_km_circular_pol( 30, 20 ) == 3.6755027981960815;
end

