using Pkg
Pkg.add("DrWatson")

using DrWatson
@quickactivate
Pkg.instantiate()

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings
gr(label = false)
using Contour

plot(x -> x^2)
savefig(plotsdir("x2"))