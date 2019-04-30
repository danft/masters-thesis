module Utils 

export Point, root2 

struct Point
	x::Real
	y::Real
end

function root2(a::Real, b::Real, c::Real)::Union{Nothing, Tuple{Real,Real}}
	Δ = b^2 - 4*a*c

	if (Δ < 0)
		return nothing 
	end

	if (a==0)
		return (b!=0) ? (-c / b, -c / b) : nothing
	end

	return (-b + √Δ) / (2*a), (-b-√Δ)/(2*a)
end

end
