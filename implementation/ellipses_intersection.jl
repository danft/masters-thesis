using Printf

struct Point
	x::Real
	y::Real
end

struct Ellipse
    a::Real
    b::Real
    center::Point
end

function root2(a::Real, b::Real, c::Real)::Union{Bool, Tuple{Real,Real}}
	Δ = b^2 - 4*a*c
	if (Δ < 0)
		return false
	end

	return (-b + √Δ) / 2*a, (-b-√Δ)/2*a
end

#Assumes that e_a.a === e_2.a
function intersection(e_1::Ellipse, e_2::Ellipse)::Union{Bool,Tuple{Point,Point}}
	h::Real = e_2.center.x - e_1.center.y
	k::Real = e_2.center.y - e_1.center.y
	a::Real = e_1.a
	b::Real = e_1.b

	α = (-2*k*a^2)/(2*h*b^2)
	β = (b^2*h^2 + a^2*k^2) / (2*h*b^2)
	
	ro = root2(b^2*α^2+a^2, 2*β*α*b^2, b^2*β^2 - a^2*b^2)

	if (ro === false)
		return false
	end
	
	y_1, y_2 = ro

	x_1 = y_1*α + β
	x_2 = y_2*α + β

	return Point(x_1,y_1), Point(x_2,y_2)
end

function main()
	ret = intersection(Ellipse(3, 2, Point(0,0)), Ellipse(3,2,Point(1,1)))

	if (ret === false)
		return
	end

	p1, p2 = ret

	@printf("%.3f %.3f\n", p1.x, p1.y)

	return ret
end

main()
