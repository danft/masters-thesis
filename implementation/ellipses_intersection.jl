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
	h::Float64 = e₂.center.x - e₁.center.y
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

	return Point(x_₁,y₁), Point(x_₂,y₂)
end
