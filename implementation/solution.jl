push!(LOAD_PATH, pwd())
using Ellipses

mutable struct PointW
	id::Int
	x::Real
	y::Real
	w::Real
end

function hash(p::PointW)::UInt64
	return p.id
end

function sum(Z::Set{PointW})
	return reduce(Z) do (pa,pb)
		return pa.w + pb.w
	end
end

function MCE1(P::AbstractArray{PointW}, E::Ellipse)::AbstractArray{Set{PointW}}
	Z::AbstractArray{Set{PointW}} = []

	n=length(P)

	for i in 1:n 
		e1 = Ellipse(E.a, E.b, P[i].x, P[i].y)
		A::AbstractArray{Tuple{Real,PointW,Int}} = []
		push!(Z, Set([P[i]]))

		for j in 1:n
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
				push!(Z, Cov)
				setdiff!(Cov, [pa[2]])
			else
				push!(Cov, pa[2])
			end
		end
	end
end

function MCE(P::AbstractArray{PointW}, E::AbstractArray{Ellipse})

end
