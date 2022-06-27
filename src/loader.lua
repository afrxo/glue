--[[

    Simple module loader.

]]

local GlueUtil = require(script.Parent.glueUtil)
local ThrowError = error

local function MakeLoader(Target: Instance, Seperator: string?)
    return function (Path: string)
        local module = GlueUtil.getInstance(string.format("%s.%s", Target:GetFullName(), Path:gsub(Seperator or "/", ".")))
        if (not module) then return end
        return require(module)
    end
end

return function (TargetDirectory: Instance, Seperator: string?)
    if (typeof(TargetDirectory) ~= "Instance") then
        ThrowError("Expected an Instance, got a " .. typeof(TargetDirectory) .. " instead.", 2)
    end

    return MakeLoader(TargetDirectory, Seperator)
end