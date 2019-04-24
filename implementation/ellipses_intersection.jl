using GeometryBase

function root2(a::Real, b::Real, c::Real)::Union{Nothing, Tuple{Real,Real}}
	Δ = b^2 - 4*a*c

	if (Δ < 0)
		return nothing 
	end

	if (a==0)
		return (-c / b, -c / b)
	end

	return (-b + √Δ) / 2*a, (-b-√Δ)/2*a
end

#Assumes that e_a.a === e_2.a
function intersection(e_1::Ellipse, e_2::Ellipse)::Union{Nothing,Tuple{Point,Point}}
	h::Real = e_2.center.x - e_1.center.y
	k::Real = e_2.center.y - e_1.center.y
	a::Real = e_1.a
	b::Real = e_1.b

	α = (-2k*a^2)/(2h*b^2)
	β = (b^2*h^2 + a^2*k^2) / (2*h*b^2)
	
	ro = root2(b^2*α^2+a^2, 2*β*α*b^2, b^2*β^2 - a^2*b^2)

	if (ro === nothing)
		return nothing 
	end
	
	y_1, y_2 = ro

	x_1 = y_1*α + β
	x_2 = y_2*α + β

	return Point(x_1,y_1), Point(x_2,y_2)
end
