#Makes julia be able to see GeometryBase
push!(LOAD_PATH, pwd())

using Plots
using Printf
using GeometryBase

include("ellipses_intersection.jl")

function main()

	e₁ = Ellipse(3,2,0,0)
	e₂ = Ellipse(3,2,1,1)

	ret = intersection(e₁, e₂)

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

	plt = plot(e₁.fx, e₁.fy, 0, 2π)
	plot!(e₂.fx, e₂.fy, 0, 2π)
	plot!([p₁.x, p₂.x], [p₁.y, p₂.y], seriestype=:scatter, series_annotations = ["+","-"])

	b1, b2 = angles(e₂, e₁)

	dfx1 = e₁.dfx(a1)	
	dfy1 = e₁.dfy(a1)

	dfx2 = -e₂.dfx(b2)
	dfy2 = -e₂.dfy(b2)
	quiver!([p₁.x, p₁.x], [p₁.y, p₁.y], quiver=([dfx1, dfx2],[dfy1, dfy2]))

	dfx1 = e₁.dfx(a2)	
	dfy1 = e₁.dfy(a2)

	dfx2 = -e₂.dfx(b1)
	dfy2 = -e₂.dfy(b1)
	quiver!([p₂.x, p₂.x], [p₂.y, p₂.y], quiver=([dfx1, dfx2],[dfy1, dfy2]))

	savefig(plt, "a.png")
	return ret
end

main()
