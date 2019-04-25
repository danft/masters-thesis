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

	p₁, p₂ = ret

	@printf("%.3f %.3f\n", p₁.x, p₁.y)

	plt = plot(e₁.fx, e₁.fy, 0, 2π)
	plot!(e₂.fx, e₂.fy, 0, 2π)
	plot!([p₁.x, p₂.x], [p₁.y, p₂.y], seriestype=:scatter)
	savefig(plt, "a.png")

	return ret
end

main()
