using Base.Test

include("RadioPropagation.jl")


@testset "RadioPropagation" begin
    @test RadioPropagation.two_ray_propagation( 2e3, 10, 12, 20e9, -1 ) == 0
end
