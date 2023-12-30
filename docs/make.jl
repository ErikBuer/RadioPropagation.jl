using Documenter, RadioPropagation

DocMeta.setdocmeta!(RadioPropagation, :DocTestSetup, :(using RadioPropagation); recursive=true)

include("../src/RadioPropagation.jl")
using .RadioPropagation

makedocs(
    modules = [RadioPropagation],
    format = Documenter.HTML(),
    sitename = "RadioPropagation.jl",
    pages = Any[
        "index.md",
    ],
)

deploydocs(
    repo = "https://github.com/ErikBuer/RadioPropagation.jl",
    target = "build",
    deps   = nothing,
    make   = nothing,
    push_preview = true,
)
