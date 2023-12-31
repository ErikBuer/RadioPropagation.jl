push!(LOAD_PATH,"../src/")

using Documenter

    # Check if LOCAL is defined; if not, set it to false
    const LOCAL = get(ENV, "LOCAL", "false") == "true"

if LOCAL
    include("../src/RadioPropagation.jl")
    using .RadioPropagation
else
    using RadioPropagation
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
    repo = "https://github.com/ErikBuer/RadioPropagation.jl",
    target = "build",
)
