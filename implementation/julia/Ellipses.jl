push!(LOAD_PATH, pwd())
module Ellipses

#import .Utils
using Utils

#exports
export Ellipse
export ellipseinter
export angles

struct Ellipse
    a::Real
    b::Real
    center::Point
	fx::Function
	fy::Function
	dfx::Function
	dfy::Function

	# No use for the center
	Ellipse(a::Real, b::Real) = Ellipse(a,b,Point(0,0))
	Ellipse(a::Real, b::Real, cx::Real, cy::Real) = Ellipse(a,b,Point(cx,cy))
	Ellipse(a::Real, b::Real, c::Point) = 
	begin 
		if (a<=0 || b<=0)
			return error("Invalid ellipse parameters")
		end

		return new(a,b,c, t-> c.x + a * cos(t), t-> c.y + b * sin(t), t->-a*sin(t), t-> b * cos(t))
	end
end

#functions

function ellipseinter(e₁::Ellipse, e₂::Ellipse)::Union{Nothing,Tuple{Point,Point}}
	h::Float64 = e₂.center.x - e₁.center.x
	k::Float64 = e₂.center.y - e₁.center.y
	a::Float64 = e₁.a
	b::Float64 = e₁.b

	if (h==0)
		error("Try to find intersection of ellipses with the same center")
	end

	α = (-2k*a^2)/(2h*b^2)
	β = (b^2*h^2 + a^2*k^2) / (2h*b^2)
	
	ro = root2(b^2*α^2+a^2, 2β*α*b^2, b^2*β^2 - a^2*b^2)

	if (ro === nothing)
		return nothing 
	end
	
	y1, y2 = ro

	x1 = y1*α + β
	x2 = y2*α + β

	return Point(x1 + e₁.center.x,y1 + e₁.center.y), Point(x2 + e₁.center.x,y2 + e₁.center.y)
end

function angles(e₁::Ellipse, e₂::Ellipse)::Union{Nothing,Tuple{Real,Real}}
	ret = ellipseinter(e₁, e₂)
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

	return u[1] * v[2] - u[2] * v[1] >= 0 ? (s1,s2) : (s2,s1)
end


end
