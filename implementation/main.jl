push!(LOAD_PATH, pwd())

using Plots
using Printf
using LaTeXStrings

include("plotting.jl")
include("solution.jl")

using Utils
using Ellipses

pgfplots()

function main2()
	e₁ = Ellipse(3,2,0,0)
	e₂ = Ellipse(3,2,first(randn(1)), first(randn(1)))
	e₃ = Ellipse(3,2,first(randn(1)),first(randn(1)))
	#e2 = Ellipse(3,2,1,1)

	plt = plotellipses([e₁, e₂, e₃])
	#plt = plotellipses([e₁, e2])

	savefig(plt, "a.pdf")
	savefig(plt, "a.tex")
end

function main3()

	e₁ = Ellipse(3,2,0,0)
	e₂ = Ellipse(3,2,first(randn(1)), first(randn(1)))
	e₃ = Ellipse(3,2,first(randn(1)),first(randn(1)))
	#e2 = Ellipse(3,2,1,1)

	plt = plotwihtoutquiver([e₁, e₂, e₃])
	#plt = plotellipses([e₁, e2])

	savefig(plt, "a.pdf")
	savefig(plt, "a.tex")

end

function main()

	P::Array{PointW} = []
	xmax = 5
	ymax = 5
	n = 20

	for i in n
		push!(P, PointW(i, rand() * xmax, rand() * ymax))
	end

	ret = ex1(P, 3, 2)

	plt = plotpointsellipse(map(p -> p.x, P), map(p -> p.y, P), ret)

	savefig(plt, "b.pdf")


	return ret
end

#main()
