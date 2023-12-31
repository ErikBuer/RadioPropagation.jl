using Documenter
using RadioPropagation

# Run doctests for RadioPropagation.jl

DocMeta.setdocmeta!(RadioPropagation, :DocTestSetup, :(using RadioPropagation); recursive=true)
Documenter.doctest(RadioPropagation)