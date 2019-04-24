module GeometryBase 

export Point, Ellipse

struct Point
	x::Real
	y::Real
end

struct Ellipse
    a::Real
    b::Real
    center::Point
	fx::Function
	fy::Function

	Ellipse(a::Real, b::Real, cx::Real, cy::Real) = Ellipse(a,b,Point(cx,cy))

	Ellipse(a::Real, b::Real, c::Point) = 
	begin 
		if (a<=0 || b<=0)
			return error("Invalid ellipse parameters")
		end

		return new(a,b,c, t-> c.x + a * cos(t), t-> c.y + b * sin(t))
	end
end
end
