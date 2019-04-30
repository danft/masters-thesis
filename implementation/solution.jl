push!(LOAD_PATH, pwd())
using Ellipses

mutable struct PointW
	id::Int
	x::Real
	y::Real
	w::Real

	PointW(id::Int, x::Real, y::Real) = new(id,x,y,1)
end

mutable struct Solution
	Cover::Set{PointW}
	x::Real
	y::Real
end

function Base.isless(lhs::PointW, rhs::PointW)
	return (lhs.id != rhs.id) ? lhs.id < rhs.id : lhs.w < rhs.w
end

function hash(p::PointW)::UInt64
	return p.id
end

function sum(Z::Set{PointW})
	ret = 0
	for x in Z
		ret += x.w
	end
	return ret
end

function MCE1(P::AbstractArray{PointW}, E::Ellipse)::AbstractArray{Solution}
	Z::AbstractArray{Solution} = []

	n=length(P)

	for i in 1:n 
		e1 = Ellipse(E.a, E.b, P[i].x, P[i].y)

		#angle, point, entering or leaving
		A::AbstractArray{Tuple{Real,PointW,Int}} = [(0, P[1], 1), (2π, P[1], -1)]

		for j in i+1:n
			e2 = Ellipse(E.a, E.b, P[j].x, P[j].y)
			ret = angles(e1, e2)
			if (ret === nothing) continue end

			a1, a2 = ret

			push!(A, (a1, P[j], 1))
			push!(A, (a2, P[j], -1))
		end
		
		sort!(A)

		Cov::Set{PointW} = Set{PointW}([P[i]])

		for pa in A
			if (pa[3]==-1)
				push!(Z, Solution(copy(Cov), pa[2].x, pa[2].y))
				setdiff!(Cov, [pa[2]])
			else
				push!(Cov, pa[2])
			end
		end
	end

	return Z
end

function MCE(P::AbstractArray{PointW}, E::AbstractArray{Ellipse})

end

function MCE1(P::AbstractArray{PointW}, a::Real, b::Real)
	e::Ellipse = Ellipse(a,b)
	Z = MCE1(P,e)

	fopt = 0

	for s in Z
		zf = sum(s.Cover)
		if (zf > fopt)
			fopt = zf
		end
	end

	return fopt
end

function ex1()
	@show(MCE1([PointW(1,0,0), PointW(2, 1, 1), PointW(3,2,2)], 3,2))
end

