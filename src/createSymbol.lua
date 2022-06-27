-- createSymbol.lua
-- Create markers representing anything.

-- Create a symbol with the specified name.
return function (name: string)
    local self = newproxy(true)

    getmetatable(self).__tostring = function()
		return name
	end

	return self
end