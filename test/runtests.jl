using Test

push!(LOAD_PATH, expanduser("../"))

#include("RadioPropagation.jl")
using RadioPropagation

@testset "RadioPropagation.jl" begin
    @test RadioPropagation.two_ray_propagation( 2e3, 10, 12, 20e9, -1 ) == 0
end
