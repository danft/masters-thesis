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

	α = (-2k*a²)/(2h*b²)
	β = (b²h² + a²k²) / (2h*b²)
	
	ro = root2(b²α²+a², 2β*α*b², b²*β² - a²*b²)

	if (ro === nothing)
		return nothing 
	end
	
	y_1, y_2 = ro

	@show(y_1, y_2)
	@show(b²α²+a², 2β*α*b², b²*β² - a²*b²)


	x_1 = y_1*α + β
	x_2 = y_2*α + β

	return Point(x_1,y_1), Point(x_2,y_2)
end
