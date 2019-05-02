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

	P::Vector{PointW} = []
	xmax = 5
	ymax = 5
	n = 20

	for i in 1:n
		push!(P, PointW(i, rand() * xmax, rand() * ymax))
	end

	#ret = ex1(P, 1, 1)
	#@show(length(ret.Cover))
	#@show(ret.x, ret.y)





	ret2 = ex2(P, Ellipse(1,1), Ellipse(1.4, 1))
	plt = plotpointsellipse(map(p -> p.x, P), map(p -> p.y, P), [ret2...])
	savefig(plt, "c.pdf")

	#return ret
end

#main()
