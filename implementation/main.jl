#Makes julia be able to see GeometryBase
using Plots
using PGFPlots
using Printf
using LaTeXStrings

include("Ellipses.jl")
include("Utils.jl")
import .Utils
#import .Ellipses
using .Utils
using .Ellipses

function versor(A::AbstractArray)::AbstractArray{Real}
	hh::Real = 0
	hh = mapreduce(x->x^2, +, A)
	return map(x -> x / hh, A)
end

function main()

	e₁ = Ellipse(3,2,0,0)
	e₂ = Ellipse(3,2,1,1)
	pgfplots()  

	ret = ellipseinter(e₁, e₂)

	if (ret === nothing)
		return nothing
	end

	a1, a2 = angles(e₁, e₂)
	p₁, p₂ = (Point(e₁.fx(a1), e₁.fy(a1)),
			  Point(e₁.fx(a2), e₁.fy(a2)))

	@show(ret)
	@show(a1,a2)
	@show(p₁, p₂)

	#@printf("%.3f %.3f\n", e₁.fx(a1), p₁.y)

	plt = plot(e₁.fx, e₁.fy, 0, 2π, dpi=300, label=L"$E_1$")
	plot!(e₂.fx, e₂.fy, 0, 2π,dpi=300, label=L"E_2")
	plot!([p₁.x, p₂.x], [p₁.y, p₂.y], seriestype=:scatter,color=:black,lab="")

	b1, b2 = angles(e₂, e₁)


	dfx1 = e₁.dfx(a1)	
	dfy1 = e₁.dfy(a1)

	dfx2 = -e₂.dfx(b2)
	dfy2 = -e₂.dfy(b2)

	quiver!([p₁.x, p₁.x], [p₁.y, p₁.y], 
			gradient=(
					  versor([dfx1, dfx2]),
					  versor([dfy1, dfy2]))
			)

	dfx1 = e₁.dfx(a2)	
	dfy1 = e₁.dfy(a2)

	dfx2 = -e₂.dfx(b1)
	dfy2 = -e₂.dfy(b1)
	quiver!([p₂.x, p₂.x], [p₂.y, p₂.y], 
			quiver=(versor([dfx1, dfx2]),versor([dfy1, dfy2])),lab="")


	annotate!([(p₁.x+0.4,p₁.y-0.1,text(L"$\tiny\Gamma_+(1,2)$",pointsize=8))])

	annotate!([(p₂.x-0.4,p₂.y+0.1,text(L"$\tiny\Gamma_-(1,2)$",pointsize=8))])

	savefig(plt, "a.pdf")
	savefig(plt, "a.tex")
	return ret
end

main()
