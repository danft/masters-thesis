module Utils 

export Point, PointW, root2 

struct PointW{T<:Real}
	id::Int
	x::T
	y::T
	w::T

	#PointW{T}(id::Int, x::T, y::T) where {T<:Real} = new(id,x,y,1.0)
end

struct Point{T<:Real}
	x::T
	y::T
	Point{T}(x::T, y::T) where {T<:Real} = new(x,y)
end

#PointW(id::Int, x::T, y::T, w::T) where {T<:Real} = PointW{T}(id, x, y, w)
PointW(id::Int, x::T, y::T) where {T<:Real} = PointW{T}(id, x, y, 1.0)
PointW(id::Int, p::Point{T}, w::Float64) where {T<:Real} = PointW{T}(id, p.x, p.y, w)

Point(x::T, y::T) where {T<:Real} = Point{T}(x,y)

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
