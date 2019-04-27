include("Ellipses.jl")
include("Utils.jl")
using .Ellipses
using .Utils
using Plots
#using PGFPlots
using LaTeXStrings

function versor(A::AbstractArray)::AbstractArray{Real}
	hh::Real = 0
	hh = mapreduce(x->x^2, +, A)
	return map(x -> x / hh, A)
end

function plotellipses(E::AbstractArray{Ellipse})

	e1 = E[1]

	plt = plot(e1.fx, e1.fy, 0, 2π, dpi=300, label=L"E_1")

	for i in 2:length(E)
		ret = ellipseinter(e1, E[i])
		if (ret == nothing) continue end
		
		a1, a2 = angles(e1, E[i])
		p1, p2 = ret

		e2 = E[i]

		plot!(e2.fx, e2.fy, 0, 2π,dpi=300, label=latexstring("E_", "$i"))
		plot!([p1.x, p2.x], [p1.y, p2.y], seriestype=:scatter,color=:black,lab="")

		b1, b2 = angles(e2, e1)

		dfx1 = e1.dfx(a1)	
		dfy1 = e1.dfy(a1)

		dfx1, dfy1 = versor([dfx1, dfy1])

		dfx2 = -e2.dfx(b2)
		dfy2 = -e2.dfy(b2)
		dfx2, dfy2 = versor([dfx2, dfy2])


		quiver!([p1.x, p1.x], [p1.y, p1.y], 
				gradient=(
						  versor([dfx1, dfx2]),
						  versor([dfy1, dfy2]))
		)

		dfx1 = e1.dfx(a2)	
		dfy1 = e1.dfy(a2)
		dfx1, dfy1 = versor([dfx1, dfy1])

		dfx2 = -e2.dfx(b1)
		dfy2 = -e2.dfy(b1)
		dfx2, dfy2 = versor([dfx2, dfy2])

		quiver!([p2.x, p2.x], [p2.y, p2.y], 
				quiver=(versor([dfx1, dfx2]),versor([dfy1, dfy2])),lab="")


		annotate!([(p1.x+0.4,p1.y-0.1,
					text(latexstring(L"\tiny\Gamma_+(1,", "$i)"), pointsize=8))])

		annotate!([(p2.x-0.4,p2.y+0.1,
					text(latexstring(L"\tiny\Gamma_-(1,","$i)"),pointsize=8))])

	end

	return plt
end
