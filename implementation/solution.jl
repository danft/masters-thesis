push!(LOAD_PATH, pwd())
using Ellipses 
using Utils

struct Solution
	Cover::Set{PointW}
	p::Point
	Solution() = new(Set{PointW}(), Point(0.0, 0.0))
	Solution(Cover::Set{PointW}, p::Point{T}) where {T<:Real} = new(Cover,p)
end

function Base.isless(lhs::PointW, rhs::PointW)
	return (lhs.id != rhs.id) ? lhs.id < rhs.id : lhs.w < rhs.w
end

function Base.hash(p::PointW)::UInt64
	return p.id
end

function Base.isequal(x::PointW, y::PointW) 
	return x.id==y.id
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
		A::AbstractArray{Tuple{Real,PointW,Int}} = 
		[(0, PointW(i,e1.center,P[i].w), 1), (2π, PointW(i,e1.center,P[i].w), -1)]

		for j in i+1:n
			e2 = Ellipse(E.a, E.b, P[j].x, P[j].y)
			ret = angles(e1, e2)
			if (ret === nothing) continue end

			a1, a2 = ret

			p1 = PointW(j, e1.fx(a2), e1.fy(a2), P[j].w)
			p2 = PointW(j, e1.fx(a2), e1.fy(a2), P[j].w)

			push!(A, (a1, p1, 1))
			push!(A, (a2, p2, -1))
		end
		
		sort!(A)

		Cov::Set{PointW} = Set{PointW}()

		xx = 0

		for cnt in 1:2
			for pa in A
				if (pa[3]==-1)
					tmp::Solution = Solution(copy(Cov), Point(pa[2].x, pa[2].y))
					push!(Z,tmp)
					#if length(Cov) > 5 
					#	println(length(Cov)) 
					#	printCo(Cov)
					#end

					setdiff!(Cov, [pa[2]])
				else
					push!(Cov, pa[2])
				end
			end
		end
	end

	return Z
end

function printCo(c::Set{PointW})
	for s in c
		println(s)
	end
end

function MCE(P::AbstractArray{PointW}, E::AbstractArray{Ellipse})

end

function MCE1x(P::AbstractArray{PointW}, a::Real, b::Real)::Solution
	e::Ellipse = Ellipse(a,b)
	Z = MCE1(P,e)

	fopt = 0
	optSolution::Solution = Solution()

	for s in Z
		zf = sum(s.Cover)
		if (zf > fopt)
			fopt = zf
			optSolution = s 
		end
	end

	@show(fopt)

	return optSolution 
end

function ex1(P::AbstractArray{PointW}, a::Real, b::Real)::Ellipse
	so::Solution = MCE1x(P, a,b)

	return Ellipse(a, b, so.p.x, so.p.y)
end

function ex2(P::AbstractVector{PointW}, e1::Ellipse, e2::Ellipse)::Tuple{Ellipse,Ellipse}
	Z = [MCE1(P,e1), MCE1(P,e2)]

	fopt = 0
	opt1::Ellipse = e1
	opt2::Ellipse = e2

	for z1 in Z[1], z2 in Z[2]
		co = union(z1.Cover, z2.Cover)
		zf = sum(co)
		if (zf > fopt)
			opt1 = Ellipse(e1.a, e2.b, z1.p)
			opt2 = Ellipse(e2.a, e2.b, z2.p)
			fopt = zf
		end
	end

	@show(fopt)

	return opt1, opt2
end

