using Ellipses
using Utils
using Plots
using LaTeXStrings
using LinearAlgebra
using ColorSchemes

function versor(A::AbstractArray)::AbstractArray{Real}
	return map(x -> x / norm(A), A)
end

function plotpointsellipse(X::AbstractArray{Real}, Y::AbstractArray{Real}, E::Ellipse)
	plt = plot(X, Y, seriestype=:scatter,color=:black,lab="")

	plot!(E.fx, E.fy, 0, 2π, dpi=300, label=L"E_1", xaxis=false,yaxis=false, color=colors[1])

	return plt
end

function plotwihtoutquiver(E::AbstractArray{Ellipse})

	e1 = E[1]
	colors = [:black, ColorSchemes.hsv.colors[10], ColorSchemes.hsv.colors[28]]

	plt = plot(e1.fx, e1.fy, 0, 2π, dpi=300, label=L"E_1", xaxis=false,yaxis=false, color=colors[1])

	for i in 2:length(E)
		ret = ellipseinter(e1, E[i])
		if (ret == nothing) continue end
		
		e2 = E[i]

		a1, a2 = angles(e1, e2)
		b1, b2 = angles(e2, e1)

		#p1, p2 = Point(e2.fx(b2), e2.fy(b2)), Point(e2.fx(b1), e2.fy(b1)) 
		p1, p2 = ellipseinter(e2,e1)


		plot!(e2.fx, e2.fy, 0, 2π,dpi=300, label=latexstring("E_", "$i"), color=colors[i])
		plot!([p1.x, p2.x], [p1.y, p2.y], seriestype=:scatter,color=:black,lab="")

		#annotate!([(p1.x+0.4,p1.y-0.1,
		#			text(latexstring(L"\tiny\Gamma_+(1,", "$i)"), pointsize=8))])

		#annotate!([(p2.x-0.4,p2.y+0.1,
		#			text(latexstring(L"\tiny\Gamma_-(1,","$i)"),pointsize=8))])

	end

	return plt

end

function plotellipses(E::AbstractArray{Ellipse})

	e1 = E[1]
	colors = [:black, ColorSchemes.hsv.colors[10], ColorSchemes.hsv.colors[28]]

	plt = plot(e1.fx, e1.fy, 0, 2π, dpi=300, label=L"E_1", xaxis=false,yaxis=false, color=colors[1])

	for i in 2:length(E)
		ret = ellipseinter(e1, E[i])
		if (ret == nothing) continue end
		
		e2 = E[i]

		a1, a2 = angles(e1, e2)
		b1, b2 = angles(e2, e1)

		p1, p2 = Point(e2.fx(b2), e2.fy(b2)), Point(e2.fx(b1), e2.fy(b1)) 


		plot!(e2.fx, e2.fy, 0, 2π,dpi=300, label=latexstring("E_", "$i"), color=colors[i])
		plot!([p1.x, p2.x], [p1.y, p2.y], seriestype=:scatter,color=:black,lab="")


		dfx1 = e1.dfx(a1)	
		dfy1 = e1.dfy(a1)

		dfx1, dfy1 = versor([dfx1, dfy1])


		dfx2 = -e2.dfx(b2)
		dfy2 = -e2.dfy(b2)
		dfx2, dfy2 = versor([dfx2, dfy2])


		quiver!([p1.x], [p1.y], quiver=([dfx1], [dfy1]), color=colors[1])
		quiver!([p1.x], [p1.y], quiver=([dfx2], [dfy2]), color=colors[i])

		dfx1 = e1.dfx(a2)
		dfy1 = e1.dfy(a2)
		dfx1, dfy1 = versor([dfx1, dfy1])

		dfx2 = -e2.dfx(b1)
		dfy2 = -e2.dfy(b1)
		dfx2, dfy2 = versor([dfx2, dfy2])


		quiver!([p2.x], [p2.y], quiver=([dfx1], [dfy1]), color=colors[1])
		quiver!([p2.x], [p2.y], quiver=([dfx2], [dfy2]), color=colors[i])


		annotate!([(p1.x+0.4,p1.y-0.1,
					text(latexstring(L"\tiny\Gamma_+(1,", "$i)"), pointsize=8))])

		annotate!([(p2.x-0.4,p2.y+0.1,
					text(latexstring(L"\tiny\Gamma_-(1,","$i)"),pointsize=8))])

	end

	return plt
end
