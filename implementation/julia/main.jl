push!(LOAD_PATH, pwd())

using Plots
using Printf
using LaTeXStrings

include("plotting.jl")
include("solution.jl")

using Utils
using Ellipses

pgfplots()

function mainT()
	e1 = Ellipse(2,1,0,0)
	e2 = Ellipse(2,1,0.6,0.6)

	@show(ellipseinter(e1, e2))

end

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

	X = map(p->p.x, P)
	Y = map(p->p.y, P)

	e1, e2, iscov = ex2(P, Ellipse(1,1), Ellipse(1.4, 1))
	plt = plotpointsellipse(X, Y, [e1, e2], iscov)
	savefig(plt, "c.pdf")
	savefig(plt, "c.tex")

	@show(X)
	@show(Y)

	#return ret
end

#main()
