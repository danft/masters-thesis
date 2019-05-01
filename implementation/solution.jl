push!(LOAD_PATH, pwd())
using Ellipses 
using Utils

struct Solution
	Cover::Set{PointW}
	x::Real
	y::Real
	Solution() = new(Set{PointW}(), 0, 0)
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
				tmp::Solution = Solution(Cov, pa[2].x, pa[2].y)
				push!(Z,tmp)
				#setdiff!(Cov, [pa[2]])
			else
				push!(Cov, pa[2])
			end
		end
	end

	return Z
end

function MCE(P::AbstractArray{PointW}, E::AbstractArray{Ellipse})

end

function MCE1(P::AbstractArray{PointW}, a::Real, b::Real)::Solution
	e::Ellipse = Ellipse(a,b)
	Z = MCE1(P,e)

	fopt = 0
	optSolution = Solution()

	for s in Z
		zf = sum(s.Cover)
		if (zf > fopt)
			fopt = zf
			optSolution = zf
		end
	end

	return optSolution 
end

function ex1(P::AbstractArray{PointW}, a::Real, b::Real)::Ellipse
	so::Solution = MCE1(P, a,b)

	return Ellipse(a, b, so.x, so.y)
end

