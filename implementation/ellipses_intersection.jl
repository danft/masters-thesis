using GeometryBase

function root2(a::Real, b::Real, c::Real)::Union{Nothing, Tuple{Real,Real}}
	Δ = b^2 - 4*a*c

	if (Δ < 0)
		return nothing 
	end

	if (a==0)
		return (-c / b, -c / b)
	end

	return (-b + √Δ) / (2*a), (-b-√Δ)/(2*a)
end

#Assumes that e_a.a === e₂.a
function intersection(e₁::Ellipse, e₂::Ellipse)::Union{Nothing,Tuple{Point,Point}}
	h::Float64 = e₂.center.x - e₁.center.x
	k::Float64 = e₂.center.y - e₁.center.y
	a::Float64 = e₁.a
	b::Float64 = e₁.b

	α = (-2k*a^2)/(2h*b^2)
	β = (b^2*h^2 + a^2*k^2) / (2h*b^2)
	
	ro = root2(b^2*α^2+a^2, 2β*α*b^2, b^2*β^2 - a^2*b^2)

	if (ro === nothing)
		return nothing 
	end
	
	y₁, y₂ = ro

	x_₁ = y₁*α + β
	x_₂ = y₂*α + β

	return Point(x_₁ + e₁.center.x,y₁ + e₁.center.y), Point(x_₂ + e₁.center.x,y₂ + e₁.center.x)
end

function angles(e₁::Ellipse, e₂::Ellipse)::Union{Nothing,Tuple{Real,Real}}
	ret = intersection(e₁, e₂)
	if (ret === nothing)
		return nothing
	end

	P::Point, Q::Point = ret
	a::Real = e₁.a
	b::Real = e₂.b

	s1 = atan(a*(P.y-e₁.center.y), b*(P.x - e₁.center.x))
	s2 = atan(a*(Q.y-e₁.center.y), b*(Q.x - e₁.center.x))
	
	t1 = atan(a*(P.y-e₂.center.y), b*(P.x - e₂.center.x))
	t2 = atan(a*(Q.y-e₂.center.y), b*(Q.x - e₂.center.x))
	
	u = [e₁.dfx(s1), e₁.dfy(s1)]
	v = -[e₂.dfx(t1), e₂.dfy(t1)]

	@show (u[1] * v[2] - u[2]*v[1])

	return u[1] * v[2] - u[2] * v[1] >= 0 ? (s1,s2) : (s2,s1)
end

