--[[

	Collection of generic math functions.

]]

local ThrowError = error


local clamp = math.clamp or function(x, min, max)
	return x < min and min or x > max and max or x
end

--[=[
	@class Math
	A Collection of useful mathematical functions.
]=]
local Math = {}

--[=[
	@param a number
	@param b number
	@param t number
	@return number
]=]
function Math.Lerp(a, b, t)
	if (type(a) ~= "number") then
		ThrowError("Expected a number for a, got " .. type(a) .. ".", 2)
	end
	if (type(b) ~= "number") then
		ThrowError("Expected a number for b, got " .. type(b) .. ".", 2)
	end
	if (type(t) ~= "number") then
		ThrowError("Expected a number for t, got " .. type(t) .. ".", 2)
	end
	if (t < a) then
		return 0;
	end
	if (t >= b) then
		return 1;
	end
	return a + ( b - a ) * t
end


--[=[
	@param a number
	@param b number
	@param v number
	@return number
]=]
function Math.InverseLerp(a, b, v)
	if (type(a) ~= "number") then
		ThrowError("Expected a number for a, got " .. type(a) .. ".", 2)
	end
	if (type(b) ~= "number") then
		ThrowError("Expected a number for b, got " .. type(b) .. ".", 2)
	end
	if (type(v) ~= "number") then
		ThrowError("Expected a number for v, got " .. type(v) .. ".", 2)
	end
	return ( v - a ) / ( b - a )
end


--[=[
	@param a number
	@param b number
	@param t number
	@return number
]=]
function Math.SmoothStep(a, b, t)
	if (type(a) ~= "number") then
		ThrowError("Expected a number for a, got " .. type(a) .. ".", 2)
	end
	if (type(b) ~= "number") then
		ThrowError("Expected a number for b, got " .. type(b) .. ".", 2)
	end
	if (type(t) ~= "number") then
		ThrowError("Expected a number for t, got " .. type(t) .. ".", 2)
	end
	if (t < a) then
		return 0;
	end
	if (t >= b) then
		return 1;
	end
	t = (t - a) / (b - a);
	return t * t * (3 - 2 * t);
end


--[=[
	@param a number
	@param b number
	@param v number
	@return number
]=]
function Math.SmootherStep(a, b, v)
	if (type(a) ~= "number") then
		ThrowError("Expected a number for a, got " .. type(a) .. ".", 2)
	end
	if (type(b) ~= "number") then
		ThrowError("Expected a number for b, got " .. type(b) .. ".", 2)
	end
	if (type(v) ~= "number") then
		ThrowError("Expected a number for v, got " .. type(v) .. ".", 2)
	end
	v = clamp(Math.InverseLerp(a, b, v), 0, 1);
	return v * v * v * (v * (v * 6 - 15) + 10);
end


--[=[
	@param P0 Vector2 | Vector3
	@param P1 Vector2 | Vector3
	@return number
]=]
function Math.Slope(P0, P1)
	if (type(P0) ~= "vector") then
		ThrowError("Expected a vector for P0, got " .. type(P0) .. ".", 2)
	end
	if (type(P1) ~= "vector") then
		ThrowError("Expected a vector for P1, got " .. type(P1) .. ".", 2)
	end

	if (typeof(P0) == "Vector2") and (typeof(P1) == "Vector2") then
		return (P1.Y - P0.Y) / (P1.X - P0.X)
	elseif (typeof(P0) == "Vector3") and (typeof(P1) == "Vector3") then
		return (P1.Y - P0.Y) / (P1.X - P0.X) / (P1.Z - P0.Z)
	else
		ThrowError("Expected a Vector2 or Vector3 for P0 and P1, got " .. typeof(P0) .. " and " .. typeof(P1) .. ".", 2)
	end
end


--[=[
	@param P0 Vector2 | Vector3
	@param P1 Vector2 | Vector3
	@return number
]=]
function Math.Magnitude(P0, P1)
	if (type(P0) ~= "vector") then
		ThrowError("Expected a vector for P0, got " .. type(P0) .. ".", 2)
	end
	if (type(P1) ~= "vector") then
		ThrowError("Expected a vector for P1, got " .. type(P1) .. ".", 2)
	end
	return (P0 - P1).Magnitude
end


--[=[
	@param P0 Vector2 | Vector3
	@param P1 Vector2 | Vector3
	@return number
]=]
function Math.Direction(P0, P1)
	if (type(P0) ~= "vector") then
		ThrowError("Expected a vector for P0, got " .. type(P0) .. ".", 2)
	end
	if (type(P1) ~= "vector") then
		ThrowError("Expected a vector for P1, got " .. type(P1) .. ".", 2)
	end
	return (P0 - P1).Unit
end


--[=[
	@param Mean number
	@param Variance number
	@return number
]=]
function Math.Gaussian(Mean, Variance)
	if (type(Mean) ~= "number") then
		ThrowError("Expected a number for Mean, got " .. type(Mean) .. ".", 2)
	end
	if (type(Variance) ~= "number") then
		ThrowError("Expected a number for Variance, got " .. type(Variance) .. ".", 2)
	end
	return  math.sqrt(-2 * Variance * math.log(math.random())) * math.cos(2 * math.pi * math.random()) + Mean
end


--[=[
	@param x number
	@return boolean
]=]
function Math.IsInt(x)
	if (type (x) ~= "number") then
		return false
	end
	return math.floor(x) == x
end


--[=[
	@param x number
	@return number
]=]
function Math.Int(x)
	if (type (x) ~= "number") then
		return 0
	end
	return math.floor(x)
end


--[=[
	@param ... number
	@return number
]=]
function Math.Sum(...)
	local Total = 0
	for _, Value in {...} do
		if (type (Value) == "number") then
			Total = Total + Value
		end
	end
	return Total
end


--[=[
	@param ... number
	@return number
]=]
function Math.Mean(...)
	local Values = {...}
	return Math.Sum(...) / #Values
end

return Math