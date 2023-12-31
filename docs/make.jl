push!(LOAD_PATH,"../src/")

using Documenter


# Running `julia --project docs/make.jl` can be very slow locally.
# To speed it up during development, one can use make_local.jl instead.
# The code below checks wether its being called from make_local.jl or not.
const LOCAL = get(ENV, "LOCAL", "false") == "true"

if LOCAL
    include("../src/RadioPropagation.jl")
    using .RadioPropagation
else
    using RadioPropagation
    ENV["GKSwstype"] = "100"
end

DocMeta.setdocmeta!(RadioPropagation, :DocTestSetup, :(using RadioPropagation); recursive=true)

makedocs(
    modules = [RadioPropagation],
    format = Documenter.HTML(),
    sitename = "RadioPropagation.jl",
    pages = Any[
        "index.md",
        "Examples"  => Any[ 
                        "Examples/atmospheric_attenuation.md",
                        "Examples/two-ray_propagation.md",
                    ],
    ],
    doctest  = true,
)

deploydocs(
    repo = "github.com/ErikBuer/RadioPropagation.jl.git",
    push_preview = true,
)
